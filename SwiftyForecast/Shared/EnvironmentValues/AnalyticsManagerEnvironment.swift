//
//  AnalyticsManagerEnvironment.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/14/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//
// swiftlint:disable:implicit_getter

import Foundation
import SwiftUI

private struct AnalyticsManagerKey: EnvironmentKey {
    static let defaultValue: AnalyticsManager = AnalyticsManager(service: FirebaseAnalyticsService())
}

extension EnvironmentValues {
    var analyticsManager: AnalyticsManager {
        get { self[AnalyticsManagerKey.self] }
        set { self[AnalyticsManagerKey.self] = newValue }
    }
}

extension View {
    func analyticsManager(_ value: AnalyticsManager) -> some View {
        environment(\.analyticsManager, value)
    }
}
