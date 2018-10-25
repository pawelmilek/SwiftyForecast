//
//  SharedGroupContainer.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 05/10/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

final class SharedGroupContainer {
  private static let groupSuiteName = "group.com.pawelmilek.Swifty-Forecast"
  private static let defaults = UserDefaults(suiteName: SharedGroupContainer.groupSuiteName)
  
  
  static func setShared(city: City) {
    if let defaults = SharedGroupContainer.defaults, let encodedCity = try? JSONEncoder().encode(city) {
      defaults.set(encodedCity, forKey: "currentCity")
      defaults.synchronize()
    }
  }
  
  static func getSharedCity() -> City? {
    guard let defaults = SharedGroupContainer.defaults else { return nil }

    if let cityData = defaults.data(forKey: "currentCity"), let city = try? JSONDecoder().decode(City.self, from: cityData) {
      return city
    } else {
      return nil
    }
    
  }
  
}
