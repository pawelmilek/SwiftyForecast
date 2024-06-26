//
//  VortexSystem+Condition.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 5/31/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import Vortex

@MainActor
extension VortexSystem {
    static let lightSnow: VortexSystem = {
        VortexSystem(
            tags: ["snow"],
            position: [0.5, 0],
            shape: .box(width: 10, height: 0),
            birthRate: 60,
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
            birthRate: 500,
            lifespan: 0.5,
            speed: 3,
            speedVariation: 4,
            angle: .degrees(200),
            size: 0.01,
            sizeVariation: 0.02,
            stretchFactor: 15
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
            position: [0.27, 0.44],
            shape: .point,
            birthRate: 13,
            burstCount: 4,
            lifespan: 2,
            speed: 0.02,
            angleRange: .degrees(360),
            colors: .ramp(
                .white.opacity(1),
                .white.opacity(0.3),
                .white.opacity(0.3),
                .white.opacity(0)
            ),
            size: 1.25,
            sizeMultiplierAtDeath: 3
        )
    }()

    static let atmosphere: VortexSystem = {
        VortexSystem(
            tags: ["atmosphere"],
            position: [0.3, 0.45],
            shape: .point,
            birthRate: 2,
            idleDuration: 2,
            burstCount: 3,
            lifespan: 9,
            lifespanVariation: 0.5,
            speed: 0.01,
            angleRange: .degrees(360),
            dampingFactor: 110,
            colors: .ramp(
                .white.opacity(0.1),
                .white.opacity(0.6),
                .white.opacity(0.4),
                .white.opacity(0.3),
                .white.opacity(0)
            ),
            size: 1.25,
            sizeMultiplierAtDeath: 3
        )
    }()

    static let clouds: VortexSystem = {
        VortexSystem(
            tags: ["clouds"],
            position: [0.3, 0.45],
            shape: .point,
            birthRate: 2,
            idleDuration: 2,
            burstCount: 3,
            lifespan: 9,
            lifespanVariation: 0.5,
            speed: 0.01,
            angleRange: .degrees(360),
            colors: .ramp(
                .white.opacity(0.2),
                .white.opacity(0.6),
                .white.opacity(0.4),
                .white.opacity(0.3),
                .white.opacity(0)
            ),
            size: 1.25,
            sizeMultiplierAtDeath: 3
        )
    }()

    static let darkClouds: VortexSystem = {
        VortexSystem(
            tags: ["clouds"],
            position: [0.3, 0.45],
            shape: .point,
            birthRate: 2,
            idleDuration: 2,
            burstCount: 3,
            lifespan: 9,
            lifespanVariation: 0.5,
            speed: 0.01,
            angleRange: .degrees(360),
            colors: .ramp(
                .white.opacity(0.2),
                .white.opacity(0.6),
                .white.opacity(0.4),
                .black.opacity(0.3),
                .black.opacity(0)
            ),
            size: 1.25,
            sizeMultiplierAtDeath: 3
        )
    }()

    static let thunderstorm: VortexSystem = {
        VortexSystem(
            tags: ["thunderstorm"],
            position: [0.3, 0.65],
            shape: .ellipse(radius: 0.4),
            birthRate: 20,
            emissionDuration: 0.4,
            idleDuration: 1,
            lifespan: 0.3,
            speed: 0,
            speedVariation: 0.2,
            angleRange: .degrees(360),
            colors: .ramp(.white.opacity(1), .white.opacity(0)),
            size: 0.5,
            sizeVariation: 0.3,
            sizeMultiplierAtDeath: -1.5
        )
    }()
}
