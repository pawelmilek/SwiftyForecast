//
//  TemperatureFormatterFactory.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/16/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

protocol TemperatureFormatterFactoryProtocol {
    func make(
        by notation: TemperatureNotation,
        valueInKelvin current: Double
    ) -> temperatureDisplayable

    func make(
        by notation: TemperatureNotation,
        valueInKelvin: Temperature
    ) -> temperatureDisplayable
}

struct TemperatureFormatterFactory: TemperatureFormatterFactoryProtocol {

    func make(
        by notation: TemperatureNotation,
        valueInKelvin current: Double
    ) -> temperatureDisplayable {
        let value = Temperature(current: current)
        return make(by: notation, valueInKelvin: value)
    }

    func make(
        by notation: TemperatureNotation,
        valueInKelvin: Temperature
    ) -> temperatureDisplayable {
        switch notation {
        case .celsius:
            return TemperatureCelsiusFormatter(
                currentInKelvin: valueInKelvin.current,
                minInKelvin: valueInKelvin.min,
                maxInKelvin: valueInKelvin.max
            )

        case .fahrenheit:
            return TemperatureFahrenheitFormatter(
                currentInKelvin: valueInKelvin.current,
                minInKelvin: valueInKelvin.min,
                maxInKelvin: valueInKelvin.max
            )
        }
    }
}
