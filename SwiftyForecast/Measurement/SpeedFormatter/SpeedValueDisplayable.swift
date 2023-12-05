//
//  SpeedValueDisplayable.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/16/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

protocol SpeedValueDisplayable {
    var current: String { get }
}

extension SpeedValueDisplayable {

    func formantted(_ measurement: Measurement<UnitSpeed>) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = [.providedUnit]
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.numberFormatter.roundingMode = .up

        return formatter.string(from: measurement)
    }
}
