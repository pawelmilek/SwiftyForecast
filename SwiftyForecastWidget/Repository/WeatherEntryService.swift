//
//  WeatherEntryService.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/24/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

protocol WeatherEntryService {
    func load(latitude: Double, longitude: Double) async -> WeatherEntry
}
