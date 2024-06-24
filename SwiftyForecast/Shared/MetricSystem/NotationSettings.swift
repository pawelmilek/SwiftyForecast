//
//  NotationSettings.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/23/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

protocol NotationSettings {
    var metricSystem: MetricSystem { get set }
    var temperatureNotation: TemperatureNotation { get set }
}
