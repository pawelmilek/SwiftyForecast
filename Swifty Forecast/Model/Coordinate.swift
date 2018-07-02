//
//  Coordinate.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 27/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation


struct Coordinate {
  let latitude: Double
  let longitude: Double
}


// MARK: - CustomStringConvertible
extension Coordinate: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case latitude
    case longitude
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.latitude = try container.decode(Double.self, forKey: .latitude)
    self.longitude = try container.decode(Double.self, forKey: .longitude)
  }
}



// MARK: - CustomStringConvertible
extension Coordinate: CustomStringConvertible {
  
  var description: String {
    let textualDesc = "/\(self.latitude),\(self.longitude)"
    return textualDesc
  }
  
}
