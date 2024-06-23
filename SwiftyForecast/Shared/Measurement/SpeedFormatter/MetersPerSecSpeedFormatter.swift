//
//  MetersPerSecSpeedFormatter.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/23/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct MetersPerSecSpeedFormatter: SpeedFormatter {
    private let value: Double
    private let converter: SpeedConvertible

    init(value: Double, converter: SpeedConvertible) {
        self.value = value
        self.converter = converter
    }

    func current() -> String {
        let speed = converter.speed(value)
        return formantted(speed)
    }

    private func formantted(_ measurement: Measurement<UnitSpeed>) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = [.providedUnit]
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.numberFormatter.roundingMode = .floor
        return formatter.string(from: measurement)
    }
}
