//
//  SpeedVolumeFactory.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/16/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

protocol SpeedVolumeFactoryProtocol {
    func make(
        by measurementSystem: MeasurementSystem,
        valueInMetersPerSec: Double
    ) -> SpeedVolume
}

struct SpeedVolumeFactory: SpeedVolumeFactoryProtocol {
    func make(
        by measurementSystem: MeasurementSystem,
        valueInMetersPerSec: Double
    ) -> SpeedVolume {
        switch measurementSystem {
        case .metric:
            return SpeedVolumeMetric(value: valueInMetersPerSec)

        case .imperial:
            return SpeedVolumeImperial(value: valueInMetersPerSec)
        }
    }
}
