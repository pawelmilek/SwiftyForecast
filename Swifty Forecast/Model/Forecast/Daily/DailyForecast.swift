//
//  DailyForecast.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 30/06/2018.
//

import Foundation

struct DailyForecast: Decodable {
  var summary: String
  var icon: String
  var data: [DailyData]
}

