//
//  TemperatureVolumeFahrenheit.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/16/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct TemperatureVolumeFahrenheit: TemperatureVolume {
    private let currentInKelvin: Double
    private let maxInKelvin: Double
    private let minInKelvin: Double

    init(currentInKelvin: Double, maxInKelvin: Double, minInKelvin: Double) {
        self.currentInKelvin = currentInKelvin
        self.maxInKelvin = maxInKelvin
        self.minInKelvin = minInKelvin
    }

    var current: String {
        let temperature = toFahrenheit(currentInKelvin)
        let result = descriptive(temperature)
        return result
    }

    var max: String {
        let temperature = toFahrenheit(maxInKelvin)
        let result = descriptive(temperature)
        return result
    }

    var min: String {
        let temperature = toFahrenheit(minInKelvin)
        let result = descriptive(temperature)
        return result
    }

    private func toFahrenheit(_ value: Double) -> Measurement<UnitTemperature> {
        let inKelvin = Measurement(value: value, unit: UnitTemperature.kelvin)
        let result = inKelvin.converted(to: .fahrenheit)
        return result
    }
}
