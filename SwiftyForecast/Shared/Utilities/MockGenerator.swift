//
//  MockGenerator.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

struct MockGenerator {
    private let decoder: JSONDecoder
    private let parser: ResponseParser

    init(decoder: JSONDecoder, parser: ResponseParser) {
        self.decoder = decoder
        self.parser = parser
    }

    func generateCurrentWeatherModel() -> CurrentWeatherModel {
        do {
            let currentWeatherData = try JSONFileLoader.loadFile(with: "current_weather_response")
            let currentResponse = try decoder.decode(CurrentWeatherResponse.self, from: currentWeatherData)
            let model = parser.parse(current: currentResponse)
            return model
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func generateForecastWeatherModel() -> ForecastWeatherModel {
        do {
            let data = try JSONFileLoader.loadFile(with: "five_days_forecast_weather_response")
            let forecastResponse = try decoder.decode(ForecastWeatherResponse.self, from: data)
            let model = parser.parse(forecast: forecastResponse)
            return model
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
