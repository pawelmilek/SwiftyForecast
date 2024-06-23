//
//  ConvertedFahrenheit.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 6/22/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct ConvertedFahrenheit: TemperatureConvertible {
    func temperature(_ value: Double) -> Measurement<UnitTemperature> {
        let inKelvin = Measurement(value: value, unit: UnitTemperature.kelvin)
        let result = inKelvin.converted(to: .fahrenheit)
        return result
    }
}
