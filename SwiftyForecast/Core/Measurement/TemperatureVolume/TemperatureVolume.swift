//
//  TemperatureVolume.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/16/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

protocol TemperatureVolume {
    var current: String { get }
    var max: String { get }
    var min: String { get }
}

extension TemperatureVolume {

    func descriptive(_ measurement: Measurement<UnitTemperature>) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = [.temperatureWithoutUnit, .providedUnit]
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.numberFormatter.roundingMode = .up

        return formatter.string(from: measurement)
    }
}
