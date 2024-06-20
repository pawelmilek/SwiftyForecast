//
//  WeatherModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct WeatherModel {
    let date: Date
    let temperature: Temperature
    let condition: ConditionModel
    let humidity: Int
    let pressure: Int
    let windSpeed: Double
    let sunrise: Date
    let sunset: Date
}

extension WeatherModel {
    static let example = WeatherModel(
        date: Date(timeIntervalSinceReferenceDate: 724103328.0),
        temperature: Temperature(current: 276.14, min: 275.55, max: 276.14),
        condition: ConditionModel(id: 800, iconCode: "01d", name: "Clear", description: "clear sky"),
        humidity: 87,
        pressure: 1009,
        windSpeed: 4.63,
        sunrise: Date(timeIntervalSinceReferenceDate: 724054877.0),
        sunset: Date(timeIntervalSinceReferenceDate: 724084197.0)
    )
}
