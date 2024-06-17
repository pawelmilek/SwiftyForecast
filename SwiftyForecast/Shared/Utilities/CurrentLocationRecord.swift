//
//  LocationRecord.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/9/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import RealmSwift

protocol CurrentLocationRecordProtocol {
    func insert(_ entry: LocationModel)
}

final class CurrentLocationRecord: CurrentLocationRecordProtocol {
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
            update(stored)
        } else {
            delete(stored)
            create(entry)
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
