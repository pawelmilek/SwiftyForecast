//
//  HourlyForecastChartDataSource.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 12/2/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct HourlyForecastChartDataSource: Identifiable, Equatable {
    var id = UUID().uuidString
    let hour: String
    let temperatureValue: Int
    let temperatureFormatted: String
    let iconURL: URL?

    private let temperatureFormatterFactory: TemperatureFormatterFactoryProtocol
    private let notationController: NotationController

    init(
        model: HourlyForecastModel,
        temperatureFormatterFactory: TemperatureFormatterFactoryProtocol = TemperatureFormatterFactory(),
        notationController: NotationController = NotationController()
    ) {
        self.temperatureFormatterFactory = temperatureFormatterFactory
        self.notationController = notationController
        hour = model.date.formatted(date: .omitted, time: .shortened)

        let formatter = temperatureFormatterFactory.make(
            by: notationController.temperatureNotation,
            valueInKelvin: model.temperature
        )

        temperatureValue = formatter.currentValue
        temperatureFormatted = formatter.currentFormatted
        iconURL = WeatherEndpoint.icon(symbol: model.icon).url
    }

    static func == (lhs: HourlyForecastChartDataSource, rhs: HourlyForecastChartDataSource) -> Bool {
        lhs.id == rhs.id
    }
}
