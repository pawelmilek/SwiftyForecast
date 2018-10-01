//
//  HourlyForecast.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 01/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

struct HourlyForecast {
  var summary: String
  var icon: String
  var data: [HourlyData]
}


// MARK: - Decodable protocol
extension HourlyForecast: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case summary
    case icon
    case data
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.summary = try container.decode(String.self, forKey: .summary)
    self.icon = try container.decode(String.self, forKey: .icon)
    self.data = try Array(container.decode([HourlyData].self, forKey: .data).prefix(24))
  }
  
}
