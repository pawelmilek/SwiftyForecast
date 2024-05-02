//
//  MockModelGenerator.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

struct MockModelGenerator {
    static func generateCurrentWeatherModel() -> CurrentWeatherModel {
        do {
            let currentWeatherData = try JSONFileLoader.loadFile(with: "current_weather_response")
            let currentWeatherParser = JSONParser<CurrentWeatherResponse>(decoder: JSONDecoder())
            let currentResponse = currentWeatherParser.parse(currentWeatherData)
            let model = ResponseParser.parse(current: currentResponse)
            return model
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    static func generateForecastWeatherModel() -> ForecastWeatherModel {
        do {
            let fiveDaysForecastWeatherData = try JSONFileLoader.loadFile(with: "five_days_forecast_weather_response")
            let fiveDaysForecastWeatherParser = JSONParser<ForecastWeatherResponse>(decoder: JSONDecoder())
            let forecastResponse = fiveDaysForecastWeatherParser.parse(fiveDaysForecastWeatherData)
            let model = ResponseParser.parse(forecast: forecastResponse)
            return model
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
