//
//  Twilight.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/28/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

// swiftlint:disable switch_case_alignment
import Foundation

enum Twilight {
    case sunset(time: String)
    case sunrise(time: String)

    var symbol: String {
        return switch self {
        case .sunset: "sunset.fill"
        case .sunrise: "sunrise.fill"
        }
    }

    func getTime() -> String {
        return switch self {
        case .sunset(let time): time
        case .sunrise(let time): time
        }
    }
}
