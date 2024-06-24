//
//  ConvertedMetersPerSecond.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/23/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct ConvertedMetersPerSecond: SpeedConvertible {
    func speed(_ value: Double) -> Measurement<UnitSpeed> {
        let milesPerHour = Measurement(value: value, unit: UnitSpeed.milesPerHour)
        let converted = milesPerHour.converted(to: .metersPerSecond)
        return converted
    }
}
