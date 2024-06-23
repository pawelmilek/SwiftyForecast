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
    private let temperatureFormatterFactory: TemperatureFormatterFactoryProtocol

    init(
        icon: Data,
        date: Date,
        temperature: Temperature,
        temperatureFormatterFactory: TemperatureFormatterFactoryProtocol
    ) {
        self.icon = icon
        self.date = date
        self.temperature = temperature
        self.temperatureFormatterFactory = temperatureFormatterFactory
    }

    var formattedTemperature: String {
        temperatureFormatterFactory.make(by: temperature).current()
    }

    var time: String {
        date.formatted(date: .omitted, time: .shortened)
    }
}
