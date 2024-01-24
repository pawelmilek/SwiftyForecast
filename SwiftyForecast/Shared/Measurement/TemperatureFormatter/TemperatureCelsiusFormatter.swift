//
//  TemperatureCelsiusFormatter.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/16/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct TemperatureCelsiusFormatter: TemperatureValueDisplayable {
    private let currentInKelvin: Double
    private let maxInKelvin: Double
    private let minInKelvin: Double

    init(currentInKelvin: Double, minInKelvin: Double, maxInKelvin: Double) {
        self.currentInKelvin = currentInKelvin
        self.minInKelvin = minInKelvin
        self.maxInKelvin = maxInKelvin
    }

    var currentFormatted: String {
        let temperature = toCelsius(currentInKelvin)
        let result = formantted(temperature)
        return result
    }

    var minFormatted: String {
        let temperature = toCelsius(minInKelvin)
        let result = formantted(temperature)
        return result
    }

    var maxFormatted: String {
        let temperature = toCelsius(maxInKelvin)
        let result = formantted(temperature)
        return result
    }

    var currentValue: Int {
        let temperature = toCelsius(currentInKelvin)
        return Int(temperature.value)
    }

    var minValue: Int {
        let temperature = toCelsius(minInKelvin)
        return Int(temperature.value)
    }

    var maxValue: Int {
        let temperature = toCelsius(maxInKelvin)
        return Int(temperature.value)
    }

    private func toCelsius(_ value: Double) -> Measurement<UnitTemperature> {
        let inKelvin = Measurement(value: value, unit: UnitTemperature.kelvin)
        let result = inKelvin.converted(to: .celsius)
        return result
    }
}
