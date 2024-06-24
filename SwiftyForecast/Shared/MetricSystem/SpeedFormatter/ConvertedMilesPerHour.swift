//
//  ConvertedMilesPerHour.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/23/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct ConvertedMilesPerHour: SpeedConvertible {
    func speed(_ value: Double) -> Measurement<UnitSpeed> {
        let metersPerSecond = Measurement(value: value, unit: UnitSpeed.metersPerSecond)
        let converted = metersPerSecond.converted(to: .milesPerHour)
        return converted
    }
}
