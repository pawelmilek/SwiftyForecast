//
//  WeatherEntry+SampleTimeline.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 6/19/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import SwiftUI

extension WeatherEntry {
    static let sampleTimeline = [
        WeatherEntry(
            date: Date(),
            locationName: "Cupertino",
            icon: UIImage(resource: .cloudyDay).pngData()!,
            description: "light intensity shower rain",
            temperatureValue: TemperatureValue(current: 281, min: 278.67, max: 281),
            dayNightState: .day,
            hourly: [
                HourlyEntry(
                    icon: UIImage(resource: .rainyDay).pngData()!,
                    time: "7:00 PM",
                    temperatureValue: TemperatureValue(current: 276.46)
                ),
                HourlyEntry(
                    icon: UIImage(resource: .cloudyNight).pngData()!,
                    time: "10:00 PM",
                    temperatureValue: TemperatureValue(current: 276.46)
                ),
                HourlyEntry(
                    icon: UIImage(resource: .thunderDay).pngData()!,
                    time: "1:00 AM",
                    temperatureValue: TemperatureValue(current: 276.46)
                ),
                HourlyEntry(
                    icon: UIImage(resource: .clearDay).pngData()!,
                    time: "4:00 AM",
                    temperatureValue: TemperatureValue(current: 276.46)
                )
            ],
            temperatureRenderer: TemperatureRenderer()
        ),
        WeatherEntry(
            date: Date(),
            locationName: "Chicago",
            icon: UIImage(resource: .clearDay).pngData()!,
            description: "scattered clouds",
            temperatureValue: TemperatureValue(current: 278.93, min: 277.32, max: 278.93),
            dayNightState: .night,
            hourly: [
                HourlyEntry(
                    icon: UIImage(resource: .cloudyDay).pngData()!,
                    time: "7:00 PM",
                    temperatureValue: TemperatureValue(current: 278.93)
                ),
                HourlyEntry(
                    icon: UIImage(resource: .cloudyNight).pngData()!,
                    time: "10:00 PM",
                    temperatureValue: TemperatureValue(current: 278.93)
                ),
                HourlyEntry(
                    icon: UIImage(resource: .cloudyNight).pngData()!,
                    time: "1:00 AM",
                    temperatureValue: TemperatureValue(current: 278.93)
                ),
                HourlyEntry(
                    icon: UIImage(resource: .thunderDay).pngData()!,
                    time: "4:00 AM",
                    temperatureValue: TemperatureValue(current: 278.93)
                )
            ],
            temperatureRenderer: TemperatureRenderer()
        )
    ]
}
