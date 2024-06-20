//
//  temperatureDisplayable.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/16/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

protocol temperatureDisplayable {
    var currentFormatted: String { get }
    var minFormatted: String { get }
    var maxFormatted: String { get }

    var currentValue: Int { get }
    var minValue: Int { get }
    var maxValue: Int { get }

}

extension temperatureDisplayable {

    func formantted(_ measurement: Measurement<UnitTemperature>) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = [.temperatureWithoutUnit, .providedUnit]
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.numberFormatter.roundingMode = .floor

        return formatter.string(from: measurement)
    }
}
