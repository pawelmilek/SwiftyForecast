//
//  TemperatureFahrenheitFormatter.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/16/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct TemperatureFahrenheitFormatter: TemperatureValueDisplayable {
    private let currentInKelvin: Double
    private let maxInKelvin: Double
    private let minInKelvin: Double

    init(currentInKelvin: Double, maxInKelvin: Double, minInKelvin: Double) {
        self.currentInKelvin = currentInKelvin
        self.maxInKelvin = maxInKelvin
        self.minInKelvin = minInKelvin
    }

    var currentFormatted: String {
        let temperature = toFahrenheit(currentInKelvin)
        let result = formantted(temperature)
        return result
    }

    var maxFormatted: String {
        let temperature = toFahrenheit(maxInKelvin)
        let result = formantted(temperature)
        return result
    }

    var minFormatted: String {
        let temperature = toFahrenheit(minInKelvin)
        let result = formantted(temperature)
        return result
    }

    var currentValue: Int {
        let temperature = toFahrenheit(currentInKelvin)
        return Int(temperature.value)
    }

    var maxValue: Int {
        let temperature = toFahrenheit(maxInKelvin)
        return Int(temperature.value)
    }

    var minValue: Int {
        let temperature = toFahrenheit(minInKelvin)
        return Int(temperature.value)
    }

    private func toFahrenheit(_ value: Double) -> Measurement<UnitTemperature> {
        let inKelvin = Measurement(value: value, unit: UnitTemperature.kelvin)
        let result = inKelvin.converted(to: .fahrenheit)
        return result
    }
}
