//
//  WeatherServiceEnvironment.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/14/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import SwiftUI

private struct ClientKey: EnvironmentKey {
    static let defaultValue: Client = OpenWeatherClient(
        decoder: JSONSnakeCaseDecoded()
    )
}

extension EnvironmentValues {
    var client: Client {
        get { self[ClientKey.self] }
        set { self[ClientKey.self] = newValue }
    }
}

extension View {
    func client(_ value: Client) -> some View {
        environment(\.client, value)
    }
}
