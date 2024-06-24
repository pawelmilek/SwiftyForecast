//
//  WeatherService.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/24/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

protocol WeatherServiceProtocol {
    func weather(latitude: Double, longitude: Double) async throws -> WeatherModel
    func forecast(latitude: Double, longitude: Double) async throws -> ForecastWeatherModel
    func icon(symbol: String) async throws -> Data
    func largeIcon(symbol: String) async throws -> Data
}
