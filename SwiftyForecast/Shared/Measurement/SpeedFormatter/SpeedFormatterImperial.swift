//
//  SpeedFormatterImperial.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/16/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct SpeedFormatterImperial: SpeedValueDisplayable {
    var currentFormatted: String {
        let metersPerSecond = Measurement(value: valueMetersPerSecond, unit: UnitSpeed.metersPerSecond)
        let converted = metersPerSecond.converted(to: .milesPerHour)
        return formantted(converted)
    }

    private let valueMetersPerSecond: Double

    init(value metersPerSecond: Double) {
        valueMetersPerSecond = metersPerSecond
    }
}
