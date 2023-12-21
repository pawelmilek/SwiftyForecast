//
//  WeatherEntry.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 12/8/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import WidgetKit
import SwiftUI

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
    let icon: Image
    let description: String
    let temperatureValue: TemperatureValue
    let dayNightState: DayNightState
    let hourly: [HourlyEntry]
    private let temperatureRenderer: TemperatureRenderer

    init(
        date: Date,
        locationName: String,
        icon: Image,
        description: String,
        temperatureValue: TemperatureValue,
        dayNightState: DayNightState,
        hourly: [HourlyEntry],
        temperatureRenderer: TemperatureRenderer = TemperatureRenderer()
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

extension WeatherEntry {
    static let sampleTimeline = [
        WeatherEntry(
            date: Date(),
            locationName: "Cupertino",
            icon: Image(.cloudyDay),
            description: "light intensity shower rain",
            temperatureValue: TemperatureValue(current: 281, min: 278.67, max: 281),
            dayNightState: .day,
            hourly: [
                HourlyEntry(
                    icon: Image(.rainyDay),
                    time: "7:00 PM",
                    temperatureValue: TemperatureValue(current: 276.46)
                ),
                HourlyEntry(
                    icon: Image(.cloudyNight),
                    time: "10:00 PM",
                    temperatureValue: TemperatureValue(current: 276.46)
                ),
                HourlyEntry(
                    icon: Image(.thunderDay),
                    time: "1:00 AM",
                    temperatureValue: TemperatureValue(current: 276.46)
                ),
                HourlyEntry(
                    icon: Image(.clearDay),
                    time: "4:00 AM",
                    temperatureValue: TemperatureValue(current: 276.46)
                )
            ]
        ),
        WeatherEntry(
            date: Date(),
            locationName: "Chicago",
            icon: Image(.clearDay),
            description: "scattered clouds",
            temperatureValue: TemperatureValue(current: 278.93, min: 277.32, max: 278.93),
            dayNightState: .night,
            hourly: [
                HourlyEntry(
                    icon: Image(.cloudyDay),
                    time: "7:00 PM",
                    temperatureValue: TemperatureValue(current: 278.93)
                ),
                HourlyEntry(
                    icon: Image(.cloudyNight),
                    time: "10:00 PM",
                    temperatureValue: TemperatureValue(current: 278.93)
                ),
                HourlyEntry(
                    icon: Image(.cloudyNight),
                    time: "1:00 AM",
                    temperatureValue: TemperatureValue(current: 278.93)
                ),
                HourlyEntry(
                    icon: Image(.thunderDay),
                    time: "4:00 AM",
                    temperatureValue: TemperatureValue(current: 278.93)
                )
            ]
        )
    ]
}
