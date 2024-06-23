//
//  TemperatureFormatter.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 6/22/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

protocol TemperatureFormatter {
    func current() -> String
    func min() -> String
    func max() -> String
    func maxMin() -> String
    func current() -> Int
    func min() -> Int
    func max() -> Int
}
