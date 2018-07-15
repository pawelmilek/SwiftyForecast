//
//  WeatherForecast.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 01/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

struct WeatherForecast {
  let city: City
  let currently: CurrentForecast
  let hourly: HourlyForecast
  let daily: DailyForecast
}


extension WeatherForecast {
  
  init(city: City, forecastResponse: ForecastResponse) {
    self.city = city
    self.currently = forecastResponse.currently
    self.hourly = forecastResponse.hourly
    self.daily = forecastResponse.daily
  }
  
}
