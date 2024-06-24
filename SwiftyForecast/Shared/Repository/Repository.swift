//
//  Repository.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/24/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

protocol Repository {
    func fetchCurrent(latitude: Double, longitude: Double) async throws -> CurrentWeatherResponse
    func fetchForecast(latitude: Double, longitude: Double) async throws -> ForecastWeatherResponse
    func fetchIcon(symbol: String) async throws -> Data
    func fetchLargeIcon(symbol: String) async throws -> Data
}
