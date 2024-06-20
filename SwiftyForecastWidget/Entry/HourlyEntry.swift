//
//  HourlyEntry.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct HourlyEntry {
    let icon: Data
    let date: Date
    let temperature: Temperature
    private let temperatureRenderer: TemperatureRenderer

    init(
        icon: Data,
        date: Date,
        temperature: Temperature,
        temperatureRenderer: TemperatureRenderer = TemperatureRenderer()
    ) {
        self.icon = icon
        self.date = date
        self.temperature = temperature
        self.temperatureRenderer = temperatureRenderer
    }

    var formattedTemperature: String {
        temperatureRenderer.render(temperature).currentFormatted
    }

    var time: String {
        date.formatted(date: .omitted, time: .shortened)
    }
}
