//
//  ForecastResponse.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 30/06/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

struct ForecastResponse: Decodable {
  let latitude: Double
  let longitude: Double
  let timezone: String
  let currently: CurrentForecast
  let hourly: HourlyForecast
  let daily: DailyForecast
}
