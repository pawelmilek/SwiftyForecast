//
//  TemperatureNotation.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

enum TemperatureNotation: Int, CaseIterable {
    case fahrenheit
    case celsius

    var symbol: String {
        switch self {
        case .fahrenheit:
            UnitTemperature.fahrenheit.symbol

        case .celsius:
            UnitTemperature.celsius.symbol
        }
    }
}
