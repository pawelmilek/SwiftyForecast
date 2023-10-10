import Foundation
import RealmSwift

struct LocationDataAccessObject {
    private let realm: Realm

    init(realm: Realm = RealmProvider.shared.realm) {
        self.realm = realm
    }

    func create(_ location: LocationModel) throws {
        try realm.write {
            realm.add(location, update: .error)
        }
    }

    func read() throws -> Results<LocationModel> {
        return realm.objects(LocationModel.self)
    }

    func readSorted() throws -> Results<LocationModel> {
        let sorted = realm.objects(LocationModel.self)
            .sorted(by: [SortDescriptor(keyPath: "isUserLocation", ascending: false),
                         SortDescriptor(keyPath: "lastUpdate", ascending: true)])
        return sorted
    }

    func update(_ location: LocationModel) throws {
        guard let locationToUpdate = realm.objects(LocationModel.self)
            .where({ $0.compoundKey == location.compoundKey }).first else {
            throw RealmError.transactionFailed(description: "Object \(location) does not exist.")
        }

        try realm.write {
            locationToUpdate.compoundKey = location.compoundKey
            locationToUpdate.name = location.name
            locationToUpdate.country = location.country
            locationToUpdate.state = location.state
            locationToUpdate.postalCode = location.postalCode
            locationToUpdate.secondsFromGMT = location.secondsFromGMT
            locationToUpdate.latitude = location.latitude
            locationToUpdate.longitude = location.longitude
            locationToUpdate.lastUpdate = location.lastUpdate
            locationToUpdate.isUserLocation = location.isUserLocation
            realm.add(locationToUpdate, update: .modified)
        }
    }

    func delete(_ location: LocationModel) throws {
        try realm.write {
            realm.delete(location)
        }
    }

    func deleteAll() throws {
        try realm.write {
            let all = realm.objects(LocationModel.self)
            realm.delete(all)
        }
    }

    func checkExistanceByCompoundKey(_ location: LocationModel) -> Bool {
        guard let all = try? read(), all.first(where: { $0.compoundKey == location.compoundKey }) != nil else {
            return false
        }

        return true
    }
}
