//
//  WeatherServiceEnvironment.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/14/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//
// swiftlint:disable:implicit_getter

import Foundation
import SwiftUI

private struct WeatherServiceKey: EnvironmentKey {
    static let defaultValue: WeatherService = WeatherService(
        repository: WeatherRepository(
            client: OpenWeatherClient(
                decoder: JSONSnakeCaseDecoded()
            )
        ),
        parse: WeatherResponseParser()
    )
}

extension EnvironmentValues {
    var service: WeatherService {
        get { self[WeatherServiceKey.self] }
        set { self[WeatherServiceKey.self] = newValue }
    }
}

extension View {
    func service(_ value: WeatherService) -> some View {
        environment(\.service, value)
    }
}
