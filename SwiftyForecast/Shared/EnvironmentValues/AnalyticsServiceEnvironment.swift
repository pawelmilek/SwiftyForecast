//
//  AnalyticsServiceEnvironment.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/14/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//
// swiftlint:disable:implicit_getter

import Foundation
import SwiftUI

private struct AnalyticsServiceKey: EnvironmentKey {
    static let defaultValue: AnalyticsService = FirebaseAnalyticsService()
}

extension EnvironmentValues {
    var analyticsService: AnalyticsService {
        get { self[AnalyticsServiceKey.self] }
        set { self[AnalyticsServiceKey.self] = newValue }
    }
}

extension View {
    func analyticsService(_ value: AnalyticsService) -> some View {
        environment(\.analyticsService, value)
    }
}
