//
//  MeasurementSystem.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

enum MeasurementSystem: Int {
    case imperial
    case metric

    var locale: String {
        switch self {
        case .imperial:
            return "en_US"

        case .metric:
            return "pl_PL"
        }
    }
}
