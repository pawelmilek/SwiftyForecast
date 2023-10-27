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
            let currentResponse = JSONParser<CurrentWeatherResponse>.parse(currentWeatherData)
            let model = ResponseParser.parse(current: currentResponse)
            return model
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    static func generateForecastWeatherModel() -> ForecastWeatherModel {
        do {
            let fiveDaysForecastWeatherData = try JSONFileLoader.loadFile(with: "five_days_forecast_weather_response")
            let forecastResponse = JSONParser<ForecastWeatherResponse>.parse(fiveDaysForecastWeatherData)
            let model = ResponseParser.parse(forecast: forecastResponse)
            return model
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    static func generateLocationModel() -> LocationModel {
        do {
            let currentWeatherData = try JSONFileLoader.loadFile(with: "current_weather_response")
            let currentResponse = JSONParser<CurrentWeatherResponse>.parse(currentWeatherData)
            let locationModel = LocationModel()
            locationModel.compoundKey = "name||state||country||postalCode"
            locationModel.name = currentResponse.name
            locationModel.country = "Poland"
            locationModel.state = ""
            locationModel.postalCode = ""
            locationModel.secondsFromGMT = currentResponse.timezone
            locationModel.latitude = currentResponse.coordinate.latitude
            locationModel.longitude = currentResponse.coordinate.longitude
            locationModel.lastUpdate = Date()
            locationModel.isUserLocation = false
            return locationModel
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
