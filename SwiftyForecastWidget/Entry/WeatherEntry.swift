//
//  WeatherEntry.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 12/8/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import WidgetKit

struct WeatherEntry: TimelineEntry {
    var temperatureCurrentValue: Int {
        temperatureRenderer.render(temperatureValue).currentValue
    }

    var temperatureMinValue: Int {
        temperatureRenderer.render(temperatureValue).minValue
    }

    var temperatureMaxValue: Int {
        temperatureRenderer.render(temperatureValue).maxValue
    }

    var temperatureFormatted: String {
        temperatureRenderer.render(temperatureValue).currentFormatted
    }

    var temperatureMaxMinFormatted: String {
        temperatureRenderer.render(temperatureValue).maxMinFormatted
    }

    let date: Date
    let locationName: String
    let icon: Data
    let description: String
    let temperatureValue: TemperatureValue
    let dayNightState: DayNightState
    let hourly: [HourlyEntry]
    private let temperatureRenderer: TemperatureRenderer

    init(
        date: Date,
        locationName: String,
        icon: Data,
        description: String,
        temperatureValue: TemperatureValue,
        dayNightState: DayNightState,
        hourly: [HourlyEntry],
        temperatureRenderer: TemperatureRenderer
    ) {
        self.date = date
        self.locationName = locationName
        self.description = description
        self.icon = icon
        self.temperatureValue = temperatureValue
        self.dayNightState = dayNightState
        self.hourly = hourly
        self.temperatureRenderer = temperatureRenderer
    }
}
