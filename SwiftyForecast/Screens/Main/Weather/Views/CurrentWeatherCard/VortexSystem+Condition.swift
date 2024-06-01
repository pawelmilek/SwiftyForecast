//
//  VortexSystem+Condition.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 5/31/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import Vortex

extension VortexSystem {
    static let lightSnow: VortexSystem = {
        VortexSystem(
            tags: ["snow"],
            position: [0.5, 0],
            shape: .box(width: 10, height: 0),
            birthRate: 50,
            lifespan: 10,
            speed: 0.2,
            speedVariation: 0.2,
            angle: .degrees(180),
            angleRange: .degrees(20),
            size: 0.2,
            sizeVariation: 0.3
        )
    }()

    static let lightRain: VortexSystem = {
        VortexSystem(
            tags: ["drop"],
            position: [0.5, 0],
            shape: .box(width: 2, height: 0),
            birthRate: 300,
            lifespan: 0.5,
            speed: 2.5,
            speedVariation: 2,
            angle: .degrees(200),
            size: 0.03,
            sizeVariation: 0.05,
            stretchFactor: 5
        )
    }()

    static let thunderstorm: VortexSystem = {
        clear
    }()

    static let drizzle: VortexSystem = {
        VortexSystem(
            tags: ["drop"],
            position: [0.5, 0],
            shape: .box(width: 2, height: 0),
            birthRate: 70,
            lifespan: 0.5,
            speed: 3,
            speedVariation: 2,
            angle: .degrees(200),
            size: 0.04,
            sizeVariation: 0.05,
            stretchFactor: 5
        )
    }()

    static let clear: VortexSystem = {
        VortexSystem(
            tags: ["clear"],
            shape: .ellipse(radius: 1),
            birthRate: 80,
            lifespan: 2,
            speed: 0,
            speedVariation: 0.01,
            angleRange: .degrees(360),
            colors: .ramp(.white, .white.opacity(0.5), .white.opacity(0)),
            size: 0.01,
            sizeVariation: 0.05,
            sizeMultiplierAtDeath: 50
        )
    }()

    static let atmosphere: VortexSystem = {
        VortexSystem(
            tags: ["atmosphere"],
            position: [-0.4, 0.5],
            shape: .ellipse(radius: 1),
            birthRate: 2,
            lifespan: 20,
            speed: 0.06,
            speedVariation: 0.05,
            angle: .degrees(90),
            acceleration: [0.02, 0],
            sizeVariation: 0.9
        )
    }()

    static let clouds: VortexSystem = {
        VortexSystem(
            tags: ["clouds"],
            position: [-0.4, 0.5],
            shape: .box(width: 1, height: 1),
            birthRate: 0.7,
            lifespan: 20,
            speed: 0.08,
            speedVariation: 0.05,
            angle: .degrees(90),
            acceleration: [0.02, 0],
            sizeVariation: 0.9
        )
    }()
}
