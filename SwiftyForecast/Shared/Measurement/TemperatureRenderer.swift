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
        let minValue: Int
        let maxValue: Int
        let currentFormatted: String
        let maxMinFormatted: String
    }

    private let notationController: NotationSystemStore
    private let temperatureFormatterFactory: TemperatureFormatterFactoryProtocol

    init(
        notationController: NotationSystemStore = NotationSystemStore(),
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
            minValue: value.minValue,
            maxValue: value.maxValue,
            currentFormatted: value.currentFormatted,
            maxMinFormatted: "⏶ \(value.maxFormatted)  ⏷ \(value.minFormatted)"
        )
    }

    func render(_ source: Double) -> ReadyForDisplay {
        let value = temperatureFormatterFactory.make(
            by: notationController.temperatureNotation,
            valueInKelvin: source
        )

        return ReadyForDisplay(
            currentValue: value.currentValue,
            minValue: Int.min,
            maxValue: Int.max,
            currentFormatted: value.currentFormatted,
            maxMinFormatted: ""
        )
    }
}
