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
}

// MARK: - CustomStringConvertible protocol
extension TemperatureNotation: CustomStringConvertible {

    var description: String {
        switch self {
        case .fahrenheit:
            return "ºF"

        case .celsius:
            return "ºC"
        }
    }

}
