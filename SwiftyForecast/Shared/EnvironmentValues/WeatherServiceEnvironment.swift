//
//  WeatherServiceEnvironment.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/14/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import SwiftUI

private struct WeatherClientKey: EnvironmentKey {
    static let defaultValue: WeatherClient = OpenWeatherMapClient(
        decoder: JSONSnakeCaseDecoded()
    )
}

extension EnvironmentValues {
    var weatherClient: WeatherClient {
        get { self[WeatherClientKey.self] }
        set { self[WeatherClientKey.self] = newValue }
    }
}

extension View {
    func weatherClient(_ value: WeatherClient) -> some View {
        environment(\.weatherClient, value)
    }
}
