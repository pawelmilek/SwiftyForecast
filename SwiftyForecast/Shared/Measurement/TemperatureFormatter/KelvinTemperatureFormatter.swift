//
//  KelvinTemperatureFormatter.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 6/22/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct KelvinTemperatureFormatter: TemperatureFormatter {
    private let currentValue: Double
    private let minValue: Double
    private let maxValue: Double
    private let converter: TemperatureConvertible

    init(currentValue: Double, minValue: Double, maxValue: Double, converter: TemperatureConvertible) {
        self.currentValue = currentValue
        self.minValue = minValue
        self.maxValue = maxValue
        self.converter = converter
    }

    func current() -> String {
        let temperature = converter.temperature(currentValue)
        return formatted(temperature)
    }

    func min() -> String {
        let temperature = converter.temperature(minValue)
        return formatted(temperature)
    }

    func max() -> String {
        let temperature = converter.temperature(maxValue)
        return formatted(temperature)
    }

    func maxMin() -> String {
        "⏶ \(max())  ⏷ \(min())"
    }

    func current() -> Int {
        Int(converter.temperature(currentValue).value)
    }

    func min() -> Int {
        return Int(converter.temperature(minValue).value)
    }

    func max() -> Int {
        return Int(converter.temperature(maxValue).value)
    }

    private func formatted(_ measurement: Measurement<UnitTemperature>) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = [.temperatureWithoutUnit, .providedUnit]
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.numberFormatter.roundingMode = .floor
        return formatter.string(from: measurement)
    }
}
