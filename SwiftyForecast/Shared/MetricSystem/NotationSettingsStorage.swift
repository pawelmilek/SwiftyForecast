//
//  NotationSystemStorage.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

final class NotationSettingsStorage: NotationSettings {
    var metricSystem: MetricSystem {
        get {
            loadMetricSystem()
        }

        set(newValue) {
            saveMetricSystem(newValue)
        }
    }

    var temperatureNotation: TemperatureNotation {
        get {
            loadTemperatureNotation()
        }

        set(newValue) {
            saveTemperatureNotation(newValue)
        }
    }

    private enum Constant {
        static let appGroupContainerId = "group.com.pawelmilek.Swifty-Forecast"
        static let measurementSystem = "MeasurementSystemKey"
        static let temperatureUnit = "TemperatureUnitKey"
    }

    private let storage: UserDefaults

    init(storage: UserDefaults = UserDefaults(suiteName: Constant.appGroupContainerId)!) {
        self.storage = storage
    }

    private func loadMetricSystem() -> MetricSystem {
        let storedValue = storage.integer(forKey: Constant.measurementSystem)
        return MetricSystem(rawValue: storedValue) ?? .imperial
    }

    private func saveMetricSystem(_ value: MetricSystem) {
        storage.set(value.rawValue, forKey: Constant.measurementSystem)
    }

    private func loadTemperatureNotation() -> TemperatureNotation {
        let storedValue = storage.integer(forKey: Constant.temperatureUnit)
        let locale = UnitTemperature.locale
        let deviceUnit = TemperatureNotation.allCases.first { $0.symbol == locale.symbol } ?? .fahrenheit
        return TemperatureNotation(rawValue: storedValue) ?? deviceUnit
    }

    private func saveTemperatureNotation(_ value: TemperatureNotation) {
        storage.set(value.rawValue, forKey: Constant.temperatureUnit)
    }
}
