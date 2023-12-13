//
//  TemperatureRenderer.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 12/13/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct TemperatureRenderer {
    struct ReadyForDisplay {
        let currentValue: Int
        let current: String
        let maxMin: String

    }

    private let notationController: NotationController
    private let temperatureFormatterFactory: TemperatureFormatterFactoryProtocol

    init(
        notationController: NotationController = NotationController(),
        temperatureFormatterFactory: TemperatureFormatterFactoryProtocol = TemperatureFormatterFactory()
    ) {
        self.notationController = notationController
        self.temperatureFormatterFactory = temperatureFormatterFactory
    }

    func render(_ source: TemperatureValue) -> ReadyForDisplay {
        let value = temperatureFormatterFactory.make(
            by: notationController.temperatureNotation,
            valueInKelvin: source
        )

        return ReadyForDisplay(
            currentValue: value.currentValue,
            current: value.currentFormatted,
            maxMin: "⏶ \(value.maxFormatted)  ⏷ \(value.minFormatted)"
        )
    }

    func render(_ source: Double) -> ReadyForDisplay {
        let value = temperatureFormatterFactory.make(
            by: notationController.temperatureNotation,
            valueInKelvin: source
        )

        return ReadyForDisplay(
            currentValue: value.currentValue,
            current: value.currentFormatted,
            maxMin: ""
        )
    }
}
