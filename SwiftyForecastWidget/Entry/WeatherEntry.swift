//
//  WeatherEntry.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 12/8/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import WidgetKit

struct WeatherEntry: TimelineEntry {
    let date: Date
    let locationName: String
    let icon: Data
    let description: String
    let dayNightState: DayNightState
    let hourly: [HourlyEntry]
    private let temperatureFormatter: TemperatureFormatter

    init(
        date: Date,
        locationName: String,
        icon: Data,
        description: String,
        temperature: Temperature,
        dayNightState: DayNightState,
        hourly: [HourlyEntry],
        temperatureFormatterFactory: TemperatureFormatterFactoryProtocol
    ) {
        self.date = date
        self.locationName = locationName
        self.description = description
        self.icon = icon
        self.dayNightState = dayNightState
        self.hourly = hourly
        self.temperatureFormatter = temperatureFormatterFactory.make(by: temperature)
    }

    var currentTemperature: Int {
        temperatureFormatter.current()
    }

    var minTemperature: Int {
        temperatureFormatter.min()
    }

    var maxTemperature: Int {
        temperatureFormatter.max()
    }

    var formattedTemperature: String {
        temperatureFormatter.current()
    }

    var formattedTemperatureMaxMin: String {
        temperatureFormatter.maxMin()
    }
}
