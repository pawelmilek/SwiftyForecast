//
//  City.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation

final class City: NSObject, NSCoding {
  var name: String
  var country: String
  var coordinate: Coordinate
  
  
  init(name: String, country: String, coordinate: Coordinate) {
    self.name = name
    self.country = country
    self.coordinate = coordinate
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: "name") as! String
    self.country = aDecoder.decodeObject(forKey: "country") as! String
    self.coordinate = aDecoder.decodeObject(forKey: "coordinate") as! Coordinate
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.name, forKey: "name")
    aCoder.encode(self.country, forKey: "country")
    aCoder.encode(self.coordinate, forKey: "coordinate")
  }
}


extension City {
  
  var fullName: String {
    return "\(self.name), \(self.country)"
  }
  
}
