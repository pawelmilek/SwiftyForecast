//
//  CurrentWeatherModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct CurrentWeatherModel {
    let date: Date
    let dayNightState: DayNightState
    let temperature: Double
    let maxTemperature: Double
    let minTemperature: Double
    let description: String
    let icon: String
    let humidity: Int
    let pressure: Int
    let windSpeed: Double
    let sunrise: Date
    let sunset: Date
}

extension CurrentWeatherModel {
    static let example = CurrentWeatherModel(
        date: Date(timeIntervalSinceReferenceDate: 724103328.0),
        dayNightState: .night,
        temperature: 276.14,
        maxTemperature: 276.14,
        minTemperature: 275.55,
        description: "clear sky",
        icon: "01n",
        humidity: 87,
        pressure: 1009,
        windSpeed: 4.63,
        sunrise: Date(timeIntervalSinceReferenceDate: 724054877.0),
        sunset: Date(timeIntervalSinceReferenceDate: 724084197.0)
    )
}
