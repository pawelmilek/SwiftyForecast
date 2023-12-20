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
    var id = UUID().uuidString
    let hour: String
    let temperatureValue: Int
    let temperatureFormatted: String
    let iconURL: URL?

    init(
        model: HourlyForecastModel,
        temperatureRenderer: TemperatureRenderer = TemperatureRenderer()
    ) {
        hour = model.date.formatted(date: .omitted, time: .shortened)

        let rendered = temperatureRenderer.render(model.temperature)

        temperatureValue = rendered.currentValue
        temperatureFormatted = rendered.currentFormatted
        iconURL = WeatherEndpoint.icon(symbol: model.icon).url
    }

    static func == (lhs: HourlyForecastChartDataSource, rhs: HourlyForecastChartDataSource) -> Bool {
        lhs.id == rhs.id
    }
}
