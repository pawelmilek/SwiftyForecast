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

    private let notationSystemStore: NotationSystemStore
    private let formatterFactory: TemperatureFormatterFactoryProtocol

    init(
        notationSystemStore: NotationSystemStore = NotationSystemStore(),
        formatterFactory: TemperatureFormatterFactoryProtocol = TemperatureFormatterFactory()
    ) {
        self.notationSystemStore = notationSystemStore
        self.formatterFactory = formatterFactory
    }

    func render(_ source: Temperature) -> ReadyForDisplay {
        let value = formatterFactory.make(
            by: notationSystemStore.temperatureNotation,
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
        let value = formatterFactory.make(
            by: notationSystemStore.temperatureNotation,
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
