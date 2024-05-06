import Foundation
import RealmSwift

protocol DatabaseManager {
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
    static let shared = RealmManager(
        name: "swifty.forecast",
        pathFinder: PathFinder(fileManager: .default)
    )

    private(set) var realm: Realm!
    private let pathFinder: PathFinder

    private init(name: String, pathFinder: PathFinder) {
        self.pathFinder = pathFinder
        setupScheme(with: name)
    }

    private func setupScheme(with name: String) {
        do {
            let fileURL = try pathFinder.documentDirectory().appendingPathComponent("\(name).realm")
            let configuration = Realm.Configuration(
                fileURL: fileURL,
                schemaVersion: 1,
                deleteRealmIfMigrationNeeded: false
            )

            self.realm = try Realm(configuration: configuration)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func debugPrintRealmFileURL() {
        let realmURLAbsoluteString = realm?.configuration.fileURL?.absoluteString ?? "Invalid URL"
        debugPrint("Realm URL: \(realmURLAbsoluteString)")
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
        return realm.object(ofType: LocationModel.self, forPrimaryKey: primaryKey)
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
