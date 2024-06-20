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
    private let temperatureRenderer: TemperatureRenderer

    init(
        date: Date,
        locationName: String,
        icon: Data,
        description: String,
        temperature: Temperature,
        dayNightState: DayNightState,
        hourly: [HourlyEntry],
        temperatureRenderer: TemperatureRenderer
    ) {
        self.date = date
        self.locationName = locationName
        self.description = description
        self.icon = icon
        self.temperature = temperature
        self.dayNightState = dayNightState
        self.hourly = hourly
        self.temperatureRenderer = temperatureRenderer
    }

    var currentTemperature: Int {
        temperatureRenderer.render(temperature).currentValue
    }

    var minTemperature: Int {
        temperatureRenderer.render(temperature).minValue
    }

    var maxTemperature: Int {
        temperatureRenderer.render(temperature).maxValue
    }

    var formattedTemperature: String {
        temperatureRenderer.render(temperature).currentFormatted
    }

    var formattedTemperatureMaxMin: String {
        temperatureRenderer.render(temperature).maxMinFormatted
    }
}
