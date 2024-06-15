//
//  DayNightState.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

enum DayNightState: String, Codable, CustomStringConvertible {
    case day = "d"
    case night = "n"

    var description: String {
        switch self {
        case .day:
            return "day"

        case .night:
            return "night"
        }
    }
}
