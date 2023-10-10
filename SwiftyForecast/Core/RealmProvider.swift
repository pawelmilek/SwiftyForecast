import Foundation
import RealmSwift

struct RealmProvider {
    private static let realmName = "core.realm"

    static var shared: RealmProvider = {
        do {
            let fileURL = try PathFinder.inLibrary(realmName)
            let config = Realm.Configuration(
                fileURL: fileURL,
                schemaVersion: 1,
                deleteRealmIfMigrationNeeded: true
            )

            return RealmProvider(config: config)
        } catch {
            fatalError("Error: core.realm not load \(realmName)")
        }
    }()

    var realm: Realm {
        do {
            return try Realm(configuration: configuration)
        } catch {
            fatalError(RealmError.initializationFailed.errorDescription!)
        }
    }

    var fileURL: URL? {
        configuration.fileURL
    }

    private let configuration: Realm.Configuration

    private init(config: Realm.Configuration) {
        configuration = config
    }
}
