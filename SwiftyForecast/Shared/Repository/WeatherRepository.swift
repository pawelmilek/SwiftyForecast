//
//  OpenWeatherRepository.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/24/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct WeatherRepository: RepositoryProtocol {
    private let client: WeatherClient

    init(client: WeatherClient) {
        self.client = client
    }

    func fetchCurrent(latitude: Double, longitude: Double) async throws -> CurrentWeatherResponse {
        try await client.fetchCurrent(latitude: latitude, longitude: longitude)
    }

    func fetchForecast(latitude: Double, longitude: Double) async throws -> ForecastWeatherResponse {
       try await client.fetchForecast(latitude: latitude, longitude: longitude)
    }

    func fetchIcon(symbol: String) async throws -> Data {
        try await client.fetchIcon(symbol: symbol)
    }

    func fetchLargeIcon(symbol: String) async throws -> Data {
        try await client.fetchLargeIcon(symbol: symbol)
    }
}
