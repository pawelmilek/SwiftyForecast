//
//  WeatherClient.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import UIKit

protocol WeatherClient {
    func fetchCurrent(
        latitude: Double,
        longitude: Double
    ) async throws -> CurrentWeatherResponse

    func fetchForecast(
        latitude: Double,
        longitude: Double
    ) async throws -> ForecastWeatherResponse

    func fetchIcon(symbol: String) async throws -> UIImage
    func fetchLargeIcon(symbol: String) async throws -> UIImage
}
