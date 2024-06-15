//
//  LocationSearchCompleterEnvironment.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/14/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//
// swiftlint:disable:implicit_getter

import Foundation
import SwiftUI

private struct LocationSearchCompleterKey: EnvironmentKey {
    static let defaultValue: LocationSearchCompleter = LocationSearchCompleter()
}

extension EnvironmentValues {
    var locationSearchCompleter: LocationSearchCompleter {
        get { self[LocationSearchCompleterKey.self] }
        set { self[LocationSearchCompleterKey.self] = newValue }
    }
}

extension View {
    func locationSearchCompleter(_ value: LocationSearchCompleter) -> some View {
        environment(\.locationSearchCompleter, value)
    }
}
