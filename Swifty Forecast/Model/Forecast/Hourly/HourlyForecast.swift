//
//  HourlyForecast.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 01/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

struct HourlyForecast: Decodable {
  var summary: String
  var icon: String
  var data: [HourlyData]
}
