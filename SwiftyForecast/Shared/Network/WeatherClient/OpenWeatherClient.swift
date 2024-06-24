//
//  OpenWeatherClient.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct OpenWeatherClient: Client, HTTPClient {
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }

    func fetchCurrent(latitude: Double, longitude: Double) async throws -> CurrentWeatherResponse {
        return try await sendRequest(
            endpoint: OpenWeatherEndpoint.current(latitude: latitude, longitude: longitude),
            decoder: decoder,
            responseModel: CurrentWeatherResponse.self
        )
    }

    func fetchForecast(latitude: Double, longitude: Double) async throws -> ForecastWeatherResponse {
        return try await sendRequest(
            endpoint: OpenWeatherEndpoint.forecast(latitude: latitude, longitude: longitude),
            decoder: decoder,
            responseModel: ForecastWeatherResponse.self
        )
    }

    func fetchIcon(symbol: String) async throws -> Data {
        return try await sendRequest(
            endpoint: OpenWeatherEndpoint.icon(symbol: symbol)
        )
    }

    func fetchLargeIcon(symbol: String) async throws -> Data {
        return try await sendRequest(
            endpoint: OpenWeatherEndpoint.iconLarge(symbol: symbol)
        )
    }
}
