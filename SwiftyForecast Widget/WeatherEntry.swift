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

    init(
        date: Date,
        locationName: String,
        icon: Image,
        description: String,
        temperature: String,
        temperatureMaxMin: String
    ) {
        self.date = date
        self.locationName = locationName
        self.icon = icon
        self.description = description
        self.temperature = temperature
        self.temperatureMaxMin = temperatureMaxMin
    }
}

extension WeatherEntry {
    static let sampleTimeline = [
        WeatherEntry(
            date: Date(),
            locationName: "Cupertino",
            icon: Image(.cloudySky),
            description: "light intensity shower rain",
            temperature: "69°",
            temperatureMaxMin: "⏶ 75°  ⏷ 72°"
        ),
        WeatherEntry(
            date: Date(),
            locationName: "Cupertino",
            icon: Image(.clearSky),
            description: "scattered clouds",
            temperature: "87°",
            temperatureMaxMin: "⏶ 92°  ⏷ 45°"
        )
    ]
}
