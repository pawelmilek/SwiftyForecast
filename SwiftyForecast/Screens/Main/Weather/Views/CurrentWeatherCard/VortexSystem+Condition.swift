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
            shape: .box(width: 1.5, height: 0),
            birthRate: 300,
            lifespan: 0.5,
            speed: 3,
            speedVariation: 4,
            angle: .degrees(200),
            size: 0.01,
            sizeVariation: 0.02,
            stretchFactor: 15
        )
    }()

    static let thunderstorm: VortexSystem = {
        VortexSystem(
            tags: ["thunderstorm"],
            position: [0.3, 0.6],
            shape: .box(width: 0.7, height: 0.5),
            birthRate: 30,
            emissionDuration: 0.4,
            idleDuration: 1,
            lifespan: 0.3,
            speed: 0,
            speedVariation: 0.2,
            angleRange: .degrees(360),
            colors: .ramp( .white.opacity(1), .white.opacity(0.7), .white.opacity(0)),
            size: 0.5,
            sizeVariation: 0.5,
            sizeMultiplierAtDeath: 0.02
        )
    }()

    static let drizzle: VortexSystem = {
        VortexSystem(
            tags: ["drop"],
            position: [0.5, 0],
            shape: .box(width: 1.5, height: 0),
            birthRate: 100,
            lifespan: 0.5,
            speed: 3,
            speedVariation: 4,
            angle: .degrees(200),
            size: 0.01,
            sizeVariation: 0.02,
            stretchFactor: 15
        )
    }()

    static let clear: VortexSystem = {
        VortexSystem(
            tags: ["clear"],
            shape: .ellipse(radius: 1),
            birthRate: 40,
            lifespan: 2,
            speed: 0,
            speedVariation: 0.05,
            angleRange: .degrees(360),
            colors: .ramp(.white, .white, .white.opacity(0)),
            size: 0.01,
            sizeMultiplierAtDeath: 20
        )
    }()

    static let atmosphere: VortexSystem = {
        VortexSystem(
            tags: ["atmosphere"],
            position: [0, 0.5],
            shape: .box(width: 0.5, height: 0.5),
            birthRate: 7,
            lifespan: 13,
            speed: 0.02,
            angle: .degrees(90),
            acceleration: [0.02, 0],
            colors: .ramp( .lightGray.opacity(0.2), .lightGray.opacity(0.7), .lightGray.opacity(0.3), .lightGray.opacity(0)),
            size: 0.25,
            sizeVariation: 0.2,
            sizeMultiplierAtDeath: 10
        )
    }()

    static let clouds: VortexSystem = {
        VortexSystem(
            tags: ["clouds"],
            position: [0, 0.5],
            shape: .box(width: 0.5, height: 0.5),
            birthRate: 7,
            lifespan: 13,
            speed: 0.03,
            angle: .degrees(90),
            acceleration: [0.02, 0],
            colors: .ramp( .white.opacity(0.3), .white.opacity(0.7), .white.opacity(0.2), .white.opacity(0)),
            size: 0.25,
            sizeVariation: 0.2,
            sizeMultiplierAtDeath: 10
        )
    }()

    static let darkClouds: VortexSystem = {
        VortexSystem(
            tags: ["clouds"],
            position: [0, 0.5],
            shape: .box(width: 0.5, height: 0.5),
            birthRate: 10,
            lifespan: 13,
            speed: 0.03,
            angle: .degrees(90),
            acceleration: [0.02, 0],
            colors: .ramp( .darkGray.opacity(0.2), .white.opacity(0.6), .darkGray.opacity(0.1), .lightGray.opacity(0)),
            size: 0.25,
            sizeVariation: 0.2,
            sizeMultiplierAtDeath: 11
        )
    }()
}
