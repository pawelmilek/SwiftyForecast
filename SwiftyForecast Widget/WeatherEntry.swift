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
    let icon: Image
    let temperature: String
    let temperatureMaxMin: String
    let locationName: String
    let description: String

    init(
        date: Date,
        icon: Image,
        temperature: String,
        temperatureMaxMin: String,
        locationName: String,
        description: String
    ) {
        self.date = date
        self.icon = icon
        self.temperature = temperature
        self.temperatureMaxMin = temperatureMaxMin
        self.locationName = locationName
        self.description = description
    }
}

extension WeatherEntry {
    static let sampleTimeline = [
        WeatherEntry(
            date: Date(),
            icon: Image(.cloudySky),
            temperature: "69°",
            temperatureMaxMin: "⏶ 75°  ⏷ 72°",
            locationName: "Cupertino",
            description: "light intensity shower rain"
        ),
        WeatherEntry(
            date: Date(),
            icon: Image(.clearSky),
            temperature: "87°",
            temperatureMaxMin: "⏶ 92°  ⏷ 45°",
            locationName: "Cupertino",
            description: "scattered clouds"
        )
    ]
}
