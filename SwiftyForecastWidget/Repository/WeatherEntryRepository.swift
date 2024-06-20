//
//  WeatherEntryRepository.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/13/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherEntryRepository {
    func load(for location: CLLocation) async -> WeatherEntry
}
