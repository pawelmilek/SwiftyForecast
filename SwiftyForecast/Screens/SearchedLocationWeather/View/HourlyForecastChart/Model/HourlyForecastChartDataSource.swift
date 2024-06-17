//
//  HourlyForecastChartDataSource.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 12/2/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

// swiftlint:disable identifier_name
import Foundation

struct HourlyForecastChartDataSource: Identifiable, Equatable {
    let id = UUID().uuidString
    let hour: String
    let temperatureValue: Int
    let temperatureFormatted: String
    let iconURL: URL?

    init(
        model: HourlyForecastModel,
        temperatureRenderer: TemperatureRenderer
    ) {
        hour = model.date.formatted(date: .omitted, time: .shortened)

        if let temperature = model.temperature {
            let rendered = temperatureRenderer.render(temperature)

            temperatureValue = rendered.currentValue
            temperatureFormatted = rendered.currentFormatted
        } else {
            temperatureValue = 0
            temperatureFormatted = "--"
        }

        iconURL = WeatherEndpoint.icon(symbol: model.icon).url
    }
}
