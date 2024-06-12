//
//  UserLocationEntryValidator.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/9/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

@MainActor
struct UserLocationEntryValidator {
    private let databaseManager: DatabaseManager
    private let location: LocationModel

    private var availableUserLocation: LocationModel? {
        return try? databaseManager.readAll().first(where: { $0.isUserLocation })
    }

    init(
        location: LocationModel,
        databaseManager: DatabaseManager = RealmManager.shared
    ) {
        self.location = location
        self.databaseManager = databaseManager
    }

    @discardableResult
    func validate() -> Bool {
        let locationExist = availableUserLocation != nil
        if locationExist {
            updateIfHasCurrentEntry()
            deleteIfHasObsoleteEntry()
        } else {
            createNewEntry()
        }
        return true
    }

    private func createNewEntry() {
        do {
            try databaseManager.create(location)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func updateIfHasCurrentEntry() {
        guard isCurrentEntry else { return }
        do {
            try databaseManager.update(location)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func deleteIfHasObsoleteEntry() {
        guard !isCurrentEntry else { return }
        if let toDelete = try? databaseManager.readAll().where({ $0.isUserLocation }),
           !toDelete.isEmpty {
            do {
                try databaseManager.delete(toDelete)
                try databaseManager.create(location)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    private var isCurrentEntry: Bool {
        if (availableUserLocation?.compoundKey == location.compoundKey) &&
            (availableUserLocation?.isUserLocation == location.isUserLocation) {
            return true
        } else {
            return false
        }
    }
}
