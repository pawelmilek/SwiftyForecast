//
//  PreviewRealmManager.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/9/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import RealmSwift

final class PreviewRealmManager: DatabaseManager {
    static let shared = PreviewRealmManager()

    var previewRealm: Realm {
        var realm: Realm
        let identifier = "preview.realm"
        let config = Realm.Configuration(inMemoryIdentifier: identifier)
        do {
            realm = try Realm(configuration: config)
            let realmObjects = realm.objects(LocationModel.self)
            if realmObjects.count > 0 {
                return realm
            } else {
                try realm.write {
                    realm.add(LocationModel.examples)
                }
                return realm
            }
        } catch let error {
            fatalError("Can't bootstrap item data: \(error.localizedDescription)")
        }
    }

    func create(_ location: LocationModel) throws {
        try previewRealm.write {
            previewRealm.add(location, update: .all)
        }
    }

    func readBy(primaryKey: String) throws -> LocationModel? {
        return previewRealm.object(ofType: LocationModel.self, forPrimaryKey: primaryKey)
    }

    func readAll() throws -> Results<LocationModel> {
        return previewRealm.objects(LocationModel.self)
    }

    func readAllSorted() throws -> Results<LocationModel> {
        let sorted = previewRealm.objects(LocationModel.self)
            .sorted(by: [SortDescriptor(keyPath: "isUserLocation", ascending: false),
                         SortDescriptor(keyPath: "lastUpdate", ascending: true)])
        return sorted
    }

    func update(_ location: LocationModel) throws {
        try previewRealm.write {
            previewRealm.add(location, update: .modified)
        }
    }

    func delete(_ location: LocationModel) throws {
        try previewRealm.write {
            previewRealm.delete(location)
        }
    }

    func delete(_ locations: Results<LocationModel>) throws {
        try previewRealm.write {
            previewRealm.delete(locations)
        }
    }

    func deleteAll() throws {
        let all = previewRealm.objects(LocationModel.self)
        try previewRealm.write {
            previewRealm.delete(all)
        }
    }

}
