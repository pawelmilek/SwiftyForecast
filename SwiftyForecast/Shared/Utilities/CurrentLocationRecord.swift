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


struct CurrentLocationRecord: CurrentLocationRecordProtocol {
    private let databaseManager: DatabaseManager

    init(databaseManager: DatabaseManager) {
        self.databaseManager = databaseManager
    }

    func insert(_ entry: LocationModel) {
        if let stored = stored() {
            delete(stored)
        }
        create(entry)
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
