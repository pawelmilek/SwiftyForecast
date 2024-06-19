//
//  HourlyEntry.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct HourlyEntry {
    var temperature: String {
        temperatureRenderer.render(temperatureValue).currentFormatted
    }

    let icon: Data
    let time: String
    let temperatureValue: TemperatureValue
    private let temperatureRenderer: TemperatureRenderer

    init(
        icon: Data,
        time: String,
        temperatureValue: TemperatureValue,
        temperatureRenderer: TemperatureRenderer = TemperatureRenderer()
    ) {
        self.icon = icon
        self.time = time
        self.temperatureValue = temperatureValue
        self.temperatureRenderer = temperatureRenderer
    }
}
