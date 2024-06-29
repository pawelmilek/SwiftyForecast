//
//  WeatherClientEnvironment.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/14/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//
// swiftlint:disable:implicit_getter

import Foundation
import SwiftUI

private struct ClientKey: EnvironmentKey {
    static let defaultValue: HttpClient = OpenWeatherClient(
        decoder: JSONSnakeCaseDecoded()
    )
}

extension EnvironmentValues {
    var client: HttpClient {
        get { self[ClientKey.self] }
        set { self[ClientKey.self] = newValue }
    }
}

extension View {
    func client(_ value: HttpClient) -> some View {
        environment(\.client, value)
    }
}
