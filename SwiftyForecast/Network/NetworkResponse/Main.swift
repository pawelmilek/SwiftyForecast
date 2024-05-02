//
//  Main.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/12/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
}
