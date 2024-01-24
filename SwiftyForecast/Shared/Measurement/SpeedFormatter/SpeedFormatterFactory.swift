//
//  Formatter.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/16/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

protocol SpeedFormatterFactoryProtocol {
    func make(
        by measurementSystem: MeasurementSystem,
        valueInMetersPerSec: Double
    ) -> SpeedValueDisplayable
}

struct SpeedFormatterFactory: SpeedFormatterFactoryProtocol {
    func make(
        by measurementSystem: MeasurementSystem,
        valueInMetersPerSec: Double
    ) -> SpeedValueDisplayable {
        switch measurementSystem {
        case .metric:
            return SpeedFormatterMetric(value: valueInMetersPerSec)

        case .imperial:
            return SpeedFormatterImperial(value: valueInMetersPerSec)
        }
    }
}
