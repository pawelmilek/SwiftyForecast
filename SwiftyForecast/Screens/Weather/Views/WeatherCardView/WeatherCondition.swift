//
//  WeatherCondition.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 5/31/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import Vortex

enum WeatherCondition: Identifiable, CaseIterable {
    case thunderstorm
    case drizzle
    case rain
    case snow
    case atmosphere
    case clear
    case clouds
    case none

    init(code: Int) {
        switch code {
        case 200...232:
            self = .thunderstorm
        case 300...321:
            self = .drizzle
        case 500...531:
            self = .rain
        case 600...622:
            self = .snow
        case 701...781:
            self = .atmosphere
        case 800...800:
            self = .clear
        case 801...804:
            self = .clouds
        default:
            self = .none
        }
    }

    // swiftlint:disable:next identifier_name
    var id: Self { self }

    var code: ClosedRange<Int> {
        switch self {
        case .thunderstorm:
            return 200...232
        case .drizzle:
            return 300...321
        case .rain:
            return 500...531
        case .snow:
            return 600...622
        case .atmosphere:
            return 701...781
        case .clear:
            return 800...800
        case .clouds:
            return 801...804
        case .none:
            return 0...0
        }
    }

    var vortexSystem: VortexSystem {
        switch self {
        case .thunderstorm:
            .thunderstorm

        case .drizzle:
            .drizzle

        case .rain:
            .lightRain

        case .snow:
            .lightSnow

        case .atmosphere:
            .atmosphere

        case .clear:
            .clear

        case .clouds:
            .clouds

        case .none:
            VortexSystem(tags: ["none"])
        }
    }

    var icon: String {
        switch self {
        case .thunderstorm:
            "11d"
        case .drizzle:
            "09d"
        case .rain:
            "10d"
        case .snow:
            "13d"
        case .atmosphere:
            "50d"
        case .clear:
            "01d"
        case .clouds:
            "02d"
        case .none:
            "01d"
        }
    }
}
