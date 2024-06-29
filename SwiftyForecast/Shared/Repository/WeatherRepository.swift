//
//  WeatherRepository.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/24/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct WeatherRepository: WeatherRepositoryProtocol {
    private let client: HttpClient

    init(client: HttpClient) {
        self.client = client
    }

    func fetchCurrent(latitude: Double, longitude: Double) async throws -> CurrentWeatherResponse {
        try await client.requestCurrent(latitude: latitude, longitude: longitude)
    }

    func fetchForecast(latitude: Double, longitude: Double) async throws -> ForecastWeatherResponse {
       try await client.requestForecast(latitude: latitude, longitude: longitude)
    }

    func fetchIcon(symbol: String) async throws -> Data {
        try await client.requestIcon(symbol: symbol)
    }

    func fetchLargeIcon(symbol: String) async throws -> Data {
        try await client.requestLargeIcon(symbol: symbol)
    }
}
