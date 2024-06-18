import Foundation
import RealmSwift

protocol DatabaseManager {
    var realm: Realm { get }
    var description: String { get }

    func create(_ location: LocationModel) throws
    func readBy(primaryKey: String) throws -> LocationModel?
    func readAll() throws -> Results<LocationModel>
    func readAllSorted() throws -> Results<LocationModel>
    func update(_ location: LocationModel) throws
    func delete(_ location: LocationModel) throws
    func delete(_ locations: Results<LocationModel>) throws
    func deleteAll() throws
}

final class RealmManager: DatabaseManager {
    var realm: Realm {
        do {
            let configuration = try realmConfiguration()
            return try Realm(configuration: configuration)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    var description: String {
        realm.configuration.fileURL?.absoluteString ?? "Invalid URL"
    }

    private let name: String
    private let fileManager: FileManager

    convenience init() {
        self.init(name: "swifty.forecast", fileManager: .default)
    }

    init(name: String, fileManager: FileManager) {
        self.name = name
        self.fileManager = fileManager
    }

    private func realmConfiguration() throws -> Realm.Configuration {
        let fileURL = try documentDirectory().appendingPathComponent("\(name).realm")
        let configuration = Realm.Configuration(
            fileURL: fileURL,
            schemaVersion: 1,
            deleteRealmIfMigrationNeeded: false
        )

        return configuration
    }

    private func documentDirectory() throws -> URL {
        guard let directory = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            throw CocoaError.error(.fileReadUnsupportedScheme)
        }
        return directory
    }
}

// MARK: CRUD operations
extension RealmManager {

    func create(_ location: LocationModel) throws {
        try realm.write {
            realm.add(location, update: .all)
        }
    }

    func readBy(primaryKey: String) throws -> LocationModel? {
        realm.object(ofType: LocationModel.self, forPrimaryKey: primaryKey)
    }

    func readAll() throws -> Results<LocationModel> {
        return realm.objects(LocationModel.self)
    }

    func readAllSorted() throws -> Results<LocationModel> {
        let sorted = realm.objects(LocationModel.self)
            .sorted(by: [SortDescriptor(keyPath: "isUserLocation", ascending: false),
                         SortDescriptor(keyPath: "lastUpdate", ascending: true)])
        return sorted
    }

    func update(_ location: LocationModel) throws {
        try realm.write {
            realm.add(location, update: .modified)
        }
    }

    func delete(_ location: LocationModel) throws {
        try realm.write {
            realm.delete(location)
        }
    }

    func delete(_ locations: Results<LocationModel>) throws {
        try realm.write {
            realm.delete(locations)
        }
    }

    func deleteAll() throws {
        let all = realm.objects(LocationModel.self)
        try realm.write {
            realm.delete(all)
        }
    }
}
