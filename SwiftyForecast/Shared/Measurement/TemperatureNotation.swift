//
//  TemperatureNotation.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

enum TemperatureNotation: Int, CaseIterable {
    case fahrenheit
    case celsius

    var symbol: String {
        switch self {
        case .fahrenheit:
            "ºF"

        case .celsius:
            "ºC"
        }
    }
}
