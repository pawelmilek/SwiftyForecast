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
    let currentTemperature: Int
    let temperatureFormatted: String
    let iconURL: URL?

    init(
        model: HourlyForecastModel,
        temperatureFormatterFactory: TemperatureFormatterFactoryProtocol
    ) {
        hour = model.date.formatted(date: .omitted, time: .shortened)

        if let temperature = model.temperature {
            let formatter = temperatureFormatterFactory.make(by: Temperature(current: temperature))
            currentTemperature = formatter.current()
            temperatureFormatted = formatter.current()
        } else {
            currentTemperature = 0
            temperatureFormatted = "--"
        }

        iconURL = OpenWeatherEndpoint.icon(symbol: model.icon).url
    }
}
