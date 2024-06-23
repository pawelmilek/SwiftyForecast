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
    private let temperature: Temperature
    let dayNightState: DayNightState
    let hourly: [HourlyEntry]
    private let temperatureFormatterFactory: TemperatureFormatterFactoryProtocol

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
        self.temperature = temperature
        self.dayNightState = dayNightState
        self.hourly = hourly
        self.temperatureFormatterFactory = temperatureFormatterFactory
    }

    var currentTemperature: Int {
        temperatureFormatterFactory.make(by: temperature).current()
    }

    var minTemperature: Int {
        temperatureFormatterFactory.make(by: temperature).min()
    }

    var maxTemperature: Int {
        temperatureFormatterFactory.make(by: temperature).max()
    }

    var formattedTemperature: String {
        temperatureFormatterFactory.make(by: temperature).current()
    }

    var formattedTemperatureMaxMin: String {
        temperatureFormatterFactory.make(by: temperature).maxMin()
    }
}
