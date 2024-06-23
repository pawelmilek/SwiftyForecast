//
//  UnitTemperature+Locale.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/23/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

extension UnitTemperature {
    static var locale: UnitTemperature {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        let temperature = Measurement(value: 0, unit: UnitTemperature.celsius)
        let formatted = formatter.string(from: temperature)
        return formatted.contains(UnitTemperature.celsius.symbol) ? .celsius : .fahrenheit
    }
}
