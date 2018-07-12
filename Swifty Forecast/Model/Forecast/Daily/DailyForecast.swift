//
//  DailyForecast.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 30/06/2018.
//

import Foundation

struct DailyForecast {
  var summary: String
  var icon: String
  var data: [DailyData]
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
    self.data.removeFirst()
  }
  
}
