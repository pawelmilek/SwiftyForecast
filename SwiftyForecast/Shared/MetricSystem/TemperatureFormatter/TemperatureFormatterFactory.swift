//
//  TemperatureFormatterFactory.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/16/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

protocol TemperatureFormatterFactoryProtocol {
    func make(by temperature: Temperature) -> TemperatureFormatter
}

struct TemperatureFormatterFactory: TemperatureFormatterFactoryProtocol {
    private let notationStorage: NotationSettings

    init(notationStorage: NotationSettings) {
        self.notationStorage = notationStorage
    }

    func make(by temperature: Temperature) -> TemperatureFormatter {
        KelvinTemperatureFormatter(
            currentValue: temperature.current,
            minValue: temperature.min,
            maxValue: temperature.max,
            converter: notationStorage.temperatureNotation == .celsius
                ? ConvertedCelsius()
                : ConvertedFahrenheit()
        )
    }
}
