//
//  HttpClient.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

protocol HttpClient {
    func requestCurrent(
        latitude: Double,
        longitude: Double
    ) async throws -> CurrentWeatherResponse

    func requestForecast(
        latitude: Double,
        longitude: Double
    ) async throws -> ForecastWeatherResponse

    func requestIcon(symbol: String) async throws -> Data
    func requestLargeIcon(symbol: String) async throws -> Data
}
