//
//  TemperatureConvertible.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 6/22/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

protocol TemperatureConvertible {
    func temperature(_ value: Double) -> Measurement<UnitTemperature>
}
