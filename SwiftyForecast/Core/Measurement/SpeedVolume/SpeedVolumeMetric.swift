//
//  SpeedVolumeMetric.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/16/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct SpeedVolumeMetric: SpeedVolume {
    var current: String {
        let metersPerSecond = Measurement(value: valueMetersPerSecond, unit: UnitSpeed.metersPerSecond)
        return descriptive(metersPerSecond)
    }

    private let valueMetersPerSecond: Double

    init(value metersPerSecond: Double) {
        valueMetersPerSecond = metersPerSecond
    }
}
