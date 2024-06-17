//
//  realmManager.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/9/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import RealmSwift

final class PreviewRealmManager: DatabaseManager {
    private let identifier = "preview.realm"
    let realm: Realm

    var description: String {
        realm.configuration.fileURL?.absoluteString ?? "Invalid URL"
    }

    init() {
        let config = Realm.Configuration(inMemoryIdentifier: identifier)
        do {
            realm = try Realm(configuration: config)
            if realm.objects(LocationModel.self).count == 0 {
                try realm.write {
                    realm.add(LocationModel.examples)
                }
            }
        } catch let error {
            fatalError("Can't bootstrap item data: \(error.localizedDescription)")
        }
    }

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
