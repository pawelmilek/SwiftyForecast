import Foundation
import RealmSwift

struct RealmProvider {
  static var cities: RealmProvider = {
    return RealmProvider(config: citiesConfig)
  }()
  
  private static let citiesConfig = Realm.Configuration(fileURL: try! Path.inLibrary("cities.realm"),
                                                        schemaVersion: 1,
                                                        deleteRealmIfMigrationNeeded: true)
  
  let configuration: Realm.Configuration
  var realm: Realm {
    do {
      return try Realm(configuration: configuration)
    } catch {
      fatalError(RealmError.initializationFailed.description)
    }
  }
  
  private init(config: Realm.Configuration) {
    configuration = config
  }
}
