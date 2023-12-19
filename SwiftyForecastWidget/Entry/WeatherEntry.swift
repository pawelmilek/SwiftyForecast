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
    let date: Date
    let locationName: String
    let icon: Image
    let description: String
    let temperature: String
    let temperatureMaxMin: String
    let hourly: [HourlyEntry]

    init(
        date: Date,
        locationName: String,
        icon: Image,
        description: String,
        temperature: String,
        temperatureMaxMin: String,
        hourly: [HourlyEntry]
    ) {
        self.date = date
        self.locationName = locationName
        self.icon = icon
        self.description = description
        self.temperature = temperature
        self.temperatureMaxMin = temperatureMaxMin
        self.hourly = hourly
    }
}

extension WeatherEntry {
    static let sampleTimeline = [
        WeatherEntry(
            date: Date(),
            locationName: "Cupertino",
            icon: Image(.cloudyDay),
            description: "light intensity shower rain",
            temperature: "69°",
            temperatureMaxMin: "⏶ 75°  ⏷ 72°",
            hourly: [
                HourlyEntry(
                    icon: Image(.rainyDay),
                    temperature: "69°",
                    time: "7:00 PM"
                ),
                HourlyEntry(
                    icon: Image(.cloudyNight),
                    temperature: "65°",
                    time: "10:00 PM"
                ),
                HourlyEntry(
                    icon: Image(.thunderDay),
                    temperature: "62°",
                    time: "1:00 AM"
                ),
                HourlyEntry(
                    icon: Image(.clearDay),
                    temperature: "55°",
                    time: "4:00 AM"
                )
            ]
        ),
        WeatherEntry(
            date: Date(),
            locationName: "Cupertino",
            icon: Image(.clearDay),
            description: "scattered clouds",
            temperature: "87°",
            temperatureMaxMin: "⏶ 92°  ⏷ 45°",
            hourly: [
                HourlyEntry(
                    icon: Image(.cloudyDay),
                    temperature: "76°",
                    time: "7:00 PM"
                ),
                HourlyEntry(
                    icon: Image(.cloudyNight),
                    temperature: "75°",
                    time: "10:00 PM"
                ),
                HourlyEntry(
                    icon: Image(.cloudyNight),
                    temperature: "71°",
                    time: "1:00 AM"
                ),
                HourlyEntry(
                    icon: Image(.thunderDay),
                    temperature: "70°",
                    time: "4:00 AM"
                )
            ]
        )
    ]
}
