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

    func generateCurrentWeatherModel() -> WeatherModel {
        do {
            let resourceFile = ResourceFile(
                name: "current_weather_response",
                fileExtension: "json",
                bundle: .main
            )
            let data = try resourceFile.data()
            let currentResponse = try decoder.decode(CurrentWeatherResponse.self, from: data)
            let model = parser.weather(response: currentResponse)
            return model
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func generateForecastWeatherModel() -> ForecastModel {
        do {
            let resourceFile = ResourceFile(
                name: "five_days_forecast_weather_response",
                fileExtension: "json",
                bundle: .main
            )
            let data = try resourceFile.data()
            let forecastResponse = try decoder.decode(ForecastWeatherResponse.self, from: data)
            let model = parser.forecast(response: forecastResponse)
            return model
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
