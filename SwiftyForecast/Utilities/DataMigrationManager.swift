import Foundation
import CoreData

class DataMigrationManager {
  private lazy var currentModel: NSManagedObjectModel = .model(named: self.modelName)
  
  let enableMigrations: Bool
  let modelName: String
  let storeName: String = "SwiftyForecast"
  var stack: CoreDataStack {
    guard enableMigrations, !store(at: storeURL, isCompatibleWithModel: currentModel) else { return CoreDataStack(modelName: modelName) }
    performMigration()
    return CoreDataStack(modelName: modelName)
  }
  
  
  init(modelNamed: String, enableMigrations: Bool = false) {
    self.modelName = modelNamed
    self.enableMigrations = enableMigrations
  }
  
  
  private var applicationSupportURL: URL {
    let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first
    return URL(fileURLWithPath: path!)
  }
  
  private lazy var storeURL: URL = {
    let storeFileName = "\(self.storeName).sqlite"
    return URL(fileURLWithPath: storeFileName, relativeTo: self.applicationSupportURL)
  }()
  
  private var storeModel: NSManagedObjectModel? {
    return NSManagedObjectModel.modelVersionsFor(modelNamed: modelName).filter {self.store(at: storeURL, isCompatibleWithModel: $0)}.first
  }
  
  private func store(at storeURL: URL, isCompatibleWithModel model: NSManagedObjectModel) -> Bool {
    let storeMetadata = metadataForStoreAtURL(storeURL: storeURL)
    return model.isConfiguration(withName: nil, compatibleWithStoreMetadata:storeMetadata)
  }
  
  private func metadataForStoreAtURL(storeURL: URL) -> [String: Any] {
    let metadata: [String: Any]
    do {
      metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType, at: storeURL, options: nil)
    } catch {
      metadata = [:]
      debugPrint("Error retrieving metadata for store at URL:\(storeURL): \(error)")
    }
    return metadata
  }
  
  func performMigration() {
    if !currentModel.isVersion3 {
      fatalError("Can only handle migrations to version 3!")
    }
    
    if let storeModel = self.storeModel {
      if storeModel.isVersion1 {
        let destinationModel = NSManagedObjectModel.version2
        migrateStoreAt(URL: storeURL, fromModel: storeModel, toModel: destinationModel)
        performMigration()
        
      } else if storeModel.isVersion2 {
        let destinationModel = NSManagedObjectModel.version3
        let mappingModel = NSMappingModel(from: nil, forSourceModel: storeModel, destinationModel: destinationModel)
        migrateStoreAt(URL: storeURL, fromModel: storeModel,toModel: destinationModel, mappingModel: mappingModel)
        performMigration()
        
      } else if storeModel.isVersion3 {
        let destinationModel = NSManagedObjectModel.version3
        let mappingModel = NSMappingModel(from: nil, forSourceModel: storeModel, destinationModel: destinationModel)
        migrateStoreAt(URL: storeURL, fromModel: storeModel,toModel: destinationModel, mappingModel: mappingModel)
      }
    }
  }
  
  private func migrateStoreAt(URL storeURL: URL, fromModel from: NSManagedObjectModel, toModel to: NSManagedObjectModel, mappingModel: NSMappingModel? = nil) {
    // 1
    let migrationManager = NSMigrationManager(sourceModel: from, destinationModel: to)
    // 2
    var migrationMappingModel: NSMappingModel
    if let mappingModel = mappingModel {
      migrationMappingModel = mappingModel
    } else {
      migrationMappingModel = try! NSMappingModel.inferredMappingModel(forSourceModel: from, destinationModel: to)
    }
    
    // 3
    let targetURL = storeURL.deletingLastPathComponent()
    let destinationName = storeURL.lastPathComponent + "~1"
    let destinationURL = targetURL.appendingPathComponent(destinationName)
    debugPrint("From Model: \(from.entityVersionHashesByName)")
    debugPrint("To Model: \(to.entityVersionHashesByName)")
    debugPrint("Migrating store \(storeURL) to \(destinationURL)")
    debugPrint("Mapping model: \(String(describing: mappingModel))")
    // 4
    let success: Bool
    do {
      try migrationManager.migrateStore(from: storeURL, sourceType: NSSQLiteStoreType, options: nil, with: migrationMappingModel,
                                        toDestinationURL: destinationURL, destinationType: NSSQLiteStoreType, destinationOptions: nil)
      success = true
    } catch {
      success = false
      debugPrint("Migration failed: \(error)")
    }
    // 5
    if success {
      debugPrint("Migration Completed Successfully")
      let fileManager = FileManager.default
      do {
        try fileManager.removeItem(at: storeURL)
        try fileManager.moveItem(at: destinationURL, to: storeURL)
      } catch {
        debugPrint("Error migrating \(error)")
      }
    }
  }
}

extension NSManagedObjectModel {
  
  private class func modelURLs(in modelFolder: String) -> [URL] {
    return Bundle.main.urls(forResourcesWithExtension: "mom", subdirectory: "\(modelFolder).momd") ?? []
  }
  
  class func modelVersionsFor(modelNamed modelName: String) -> [NSManagedObjectModel] {
    return modelURLs(in: modelName).compactMap(NSManagedObjectModel.init)
  }
  
  class func uncloudNotesModel(named modelName: String) -> NSManagedObjectModel {
    let model = modelURLs(in: "SwiftyForecast").filter { $0.lastPathComponent == "\(modelName).mom" }
      .first
      .flatMap(NSManagedObjectModel.init)
    return model ?? NSManagedObjectModel()
  }
  
  class var version1: NSManagedObjectModel {
    return uncloudNotesModel(named: "SwiftyForecast")
  }
  
  var isVersion1: Bool {
    return self == type(of: self).version1
  }
  
  class var version2: NSManagedObjectModel {
    return uncloudNotesModel(named: "SwiftyForecast_v2")
  }
  
  var isVersion2: Bool {
    return self == type(of: self).version2
  }
  
  class var version3: NSManagedObjectModel {
    return uncloudNotesModel(named: "SwiftyForecast_v3")
  }
  
  var isVersion3: Bool {
    return self == type(of: self).version3
  }
  
  class func model(named modelName: String, in bundle: Bundle = .main) -> NSManagedObjectModel {
    return bundle.url(forResource: modelName, withExtension: "momd").flatMap(NSManagedObjectModel.init) ?? NSManagedObjectModel()
  }
  
}

func == (firstModel: NSManagedObjectModel, otherModel: NSManagedObjectModel) -> Bool {
  return firstModel.entitiesByName == otherModel.entitiesByName
}
