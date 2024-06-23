//
//  Formatter.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/16/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

protocol SpeedFormatterFactoryProtocol {
    func make(value: Double) -> SpeedFormatter
}

struct SpeedFormatterFactory: SpeedFormatterFactoryProtocol {
    private let notationStorage: NotationSettings

    init(notationStorage: NotationSettings) {
        self.notationStorage = notationStorage
    }

    func make(value: Double) -> SpeedFormatter {
        MetersPerSecSpeedFormatter(
            value: value,
            converter: notationStorage.measurementSystem == .metric
            ? ConvertedMetersPerSecond()
            : ConvertedMilesPerHour()
        )
    }
}
