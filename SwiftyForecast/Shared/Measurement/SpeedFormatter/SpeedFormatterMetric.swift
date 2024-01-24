//
//  SpeedFormatterMetric.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/16/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct SpeedFormatterMetric: SpeedValueDisplayable {
    var currentFormatted: String {
        let metersPerSecond = Measurement(value: valueMetersPerSecond, unit: UnitSpeed.metersPerSecond)
        return formantted(metersPerSecond)
    }

    private let valueMetersPerSecond: Double

    init(value metersPerSecond: Double) {
        valueMetersPerSecond = metersPerSecond
    }
}
