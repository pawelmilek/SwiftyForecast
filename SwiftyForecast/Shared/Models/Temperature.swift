//
//  Temperature.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/25/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct Temperature {
    let current: Double
    let min: Double
    let max: Double

    init(current: Double, min: Double = 0, max: Double = 0) {
        self.current = current
        self.min = min
        self.max = max
    }
}
