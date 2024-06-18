//
//  CurrentLocationRecord.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/9/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import RealmSwift

protocol LocationRecord {
    func insert(_ entry: LocationModel)
}

final class CurrentLocationRecord: LocationRecord {
    private let databaseManager: DatabaseManager

    init(databaseManager: DatabaseManager) {
        self.databaseManager = databaseManager
    }

    func insert(_ entry: LocationModel) {
        @ThreadSafe var stored = stored()

        guard let stored else {
            create(entry)
            return
        }

        if stored.compoundKey == entry.compoundKey {
            update(entry)
        } else {
            replace(existing: stored, with: entry)
        }
    }

    private func replace(existing: LocationModel, with entry: LocationModel) {
        do {
            try databaseManager.realm.write {
                databaseManager.realm.delete(existing)
                databaseManager.realm.add(entry, update: .all)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func update(_ location: LocationModel) {
        do {
            try databaseManager.update(location)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func create(_ location: LocationModel) {
        do {
            try databaseManager.create(location)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func delete(_ location: LocationModel) {
        do {
            try databaseManager.delete(location)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func stored() -> LocationModel? {
        do {
            return try databaseManager.readAll().first { $0.isUserLocation }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
