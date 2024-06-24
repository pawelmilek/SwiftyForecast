//
//  WeatherService.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/24/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct WeatherService: WeatherServiceProtocol {
    private let repository: WeatherRepository
    private let parse: ResponseParser

    init(repository: WeatherRepository, parse: ResponseParser) {
        self.repository = repository
        self.parse = parse
    }

    func weather(latitude: Double, longitude: Double) async throws -> WeatherModel {
        let response = try await repository.fetchCurrent(latitude: latitude, longitude: longitude)
        return parse.weather(response: response)
    }

    func forecast(latitude: Double, longitude: Double) async throws -> ForecastWeatherModel {
        let resposne = try await repository.fetchForecast(latitude: latitude, longitude: longitude)
        return parse.forecast(response: resposne)
    }

    func icon(symbol: String) async throws -> Data {
        try await repository.fetchIcon(symbol: symbol)
    }

    func largeIcon(symbol: String) async throws -> Data {
        try await repository.fetchLargeIcon(symbol: symbol)
    }
}
