//
//  ForecastResponse.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 30/06/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

struct ForecastResponse {
  let coordinate: Coordinate
  let timezone: String
  let currently: CurrentForecast
  let hourly: HourlyForecast
  let daily: DailyForecast
}


// MARK: - Decodable protocol
extension ForecastResponse: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case timezone
    case currently
    case hourly
    case daily
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.coordinate = try Coordinate(from: decoder)
    self.timezone = try container.decode(String.self, forKey: .timezone)
    self.currently = try container.decode(CurrentForecast.self, forKey: .currently)
    self.hourly = try container.decode(HourlyForecast.self, forKey: .hourly)
    self.daily = try container.decode(DailyForecast.self, forKey: .daily)
  }
}
