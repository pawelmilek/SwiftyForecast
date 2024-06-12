//
//  SpeedRenderer.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 12/13/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct SpeedRenderer {
    private let notationController: NotationSystemStore
    private let speedFormatterFactory: SpeedFormatterFactoryProtocol

    init(
        notationController: NotationSystemStore = NotationSystemStore(),
        speedFormatterFactory: SpeedFormatterFactoryProtocol = SpeedFormatterFactory()
    ) {
        self.notationController = notationController
        self.speedFormatterFactory = speedFormatterFactory
    }

    func render(_ source: Double) -> String {
        let value = speedFormatterFactory.make(
            by: notationController.measurementSystem,
            valueInMetersPerSec: source
        )

        return value.currentFormatted
    }
}
