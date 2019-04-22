//
//  DailyForecast.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 30/06/2018.
//

import Foundation

struct DailyForecast {
  let summary: String
  let icon: String
  private let data: [DailyData]
}


// MARK: - Number of days (exclude current day)
extension DailyForecast {
  
  var numberOfDays: Int {
    return data.count - 1
  }
  
  var sevenDaysData: [DailyData] {
    let sevenDaysData = Array(data.dropFirst())
    return sevenDaysData
  }
  
  var currentDayData: DailyData? {
    return data.first
  }
}


// MARK: - Decodable protocol
extension DailyForecast: Decodable {
  enum CodingKeys: String, CodingKey {
    case summary
    case icon
    case data
  }
  
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.summary = try container.decode(String.self, forKey: .summary)
    self.icon = try container.decode(String.self, forKey: .icon)
    self.data = try container.decode([DailyData].self, forKey: .data)
  }
  
}
