//
//  DatabaseManagerKey.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/17/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//
// swiftlint:disable:implicit_getter

import Foundation
import SwiftUI

private struct DatabaseManagerKey: EnvironmentKey {
    static let defaultValue: DatabaseManager = RealmManager()
}

extension EnvironmentValues {
    var databaseManager: DatabaseManager {
        get { self[DatabaseManagerKey.self] }
        set { self[DatabaseManagerKey.self] = newValue }
    }
}

extension View {
    func databaseManager(_ value: DatabaseManager) -> some View {
        environment(\.databaseManager, value)
    }
}
