import Foundation
import RealmSwift

struct RealmProvider {
  static var core: RealmProvider = {
    return RealmProvider(config: config)
  }()
  
  private static let config = Realm.Configuration(fileURL: try! PathFinder.inLibrary("core.realm"),
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
