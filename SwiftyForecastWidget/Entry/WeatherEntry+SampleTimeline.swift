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
    private static let temperatureFormatterFactory = TemperatureFormatterFactory(
        notation: NotationSystemStore().temperatureNotation
    )

    static let sampleTimeline = [
        WeatherEntry(
            date: Date(),
            locationName: "Cupertino",
            icon: UIImage(resource: .cloudyDay).pngData()!,
            description: "light intensity shower rain",
            temperature: Temperature(current: 281, min: 278.67, max: 281),
            dayNightState: .day,
            hourly: [
                HourlyEntry(
                    icon: UIImage(resource: .rainyDay).pngData()!,
                    date: .now,
                    temperature: Temperature(current: 276.46),
                    temperatureFormatterFactory: temperatureFormatterFactory
                ),
                HourlyEntry(
                    icon: UIImage(resource: .cloudyNight).pngData()!,
                    date: Calendar.current.date(byAdding: .hour, value: 3, to: .now)!,
                    temperature: Temperature(current: 276.46),
                    temperatureFormatterFactory: temperatureFormatterFactory
                ),
                HourlyEntry(
                    icon: UIImage(resource: .thunderDay).pngData()!,
                    date: Calendar.current.date(byAdding: .hour, value: 6, to: .now)!,
                    temperature: Temperature(current: 276.46),
                    temperatureFormatterFactory: temperatureFormatterFactory
                ),
                HourlyEntry(
                    icon: UIImage(resource: .clearDay).pngData()!,
                    date: Calendar.current.date(byAdding: .hour, value: 9, to: .now)!,
                    temperature: Temperature(current: 276.46),
                    temperatureFormatterFactory: temperatureFormatterFactory
                )
            ],
            temperatureFormatterFactory: temperatureFormatterFactory
        ),
        WeatherEntry(
            date: Date(),
            locationName: "Chicago",
            icon: UIImage(resource: .clearDay).pngData()!,
            description: "scattered clouds",
            temperature: Temperature(current: 278.93, min: 277.32, max: 278.93),
            dayNightState: .night,
            hourly: [
                HourlyEntry(
                    icon: UIImage(resource: .cloudyDay).pngData()!,
                    date: .now,
                    temperature: Temperature(current: 278.93),
                    temperatureFormatterFactory: temperatureFormatterFactory
                ),
                HourlyEntry(
                    icon: UIImage(resource: .cloudyNight).pngData()!,
                    date: Calendar.current.date(byAdding: .hour, value: 3, to: .now)!,
                    temperature: Temperature(current: 278.93),
                    temperatureFormatterFactory: temperatureFormatterFactory
                ),
                HourlyEntry(
                    icon: UIImage(resource: .cloudyNight).pngData()!,
                    date: Calendar.current.date(byAdding: .hour, value: 6, to: .now)!,
                    temperature: Temperature(current: 278.93),
                    temperatureFormatterFactory: temperatureFormatterFactory
                ),
                HourlyEntry(
                    icon: UIImage(resource: .thunderDay).pngData()!,
                    date: Calendar.current.date(byAdding: .hour, value: 9, to: .now)!,
                    temperature: Temperature(current: 278.93),
                    temperatureFormatterFactory: temperatureFormatterFactory
                )
            ],
            temperatureFormatterFactory: temperatureFormatterFactory
        )
    ]
}
