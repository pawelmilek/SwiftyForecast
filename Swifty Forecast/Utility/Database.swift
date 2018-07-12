//
//  Database.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 28/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation


final class Database {
  static let shared = Database()
  
  private let citiesKey = "Cities"
  var cities = [ City(name: "Dublin", country: "Ireland", coordinate: Coordinate(latitude: 53.349805, longitude: -6.260310)),
                 City(name: "London", country: "England", coordinate: Coordinate(latitude: 51.507351, longitude: -0.127758)),
                 City(name: "New York", country: "US", coordinate: Coordinate(latitude: 40.712784, longitude: -74.005941)),
                 City(name: "Barcelona", country: "Spain", coordinate: Coordinate(latitude: 41.385064, longitude: 2.173403)) ]
  
  
  
  init() {
    self.load()
  }
  
  
  private func save(cities: [City]) {
    let citiesData = NSKeyedArchiver.archivedData(withRootObject: cities)
    
    let userPref = UserDefaults.standard
    userPref.set(citiesData, forKey: self.citiesKey)
  }
  
  private func load() {
    let userPref = UserDefaults.standard
    
    guard let archivedCitiesData = userPref.object(forKey: self.citiesKey) as? Data else {
      self.save(cities: self.cities)
      return
    }
    
    // unarchive object
    if let unarchiveCities = NSKeyedUnarchiver.unarchiveObject(with: archivedCitiesData) as? [City] {
      self.cities = unarchiveCities
    }
  }
}


// MARK: - Insert and Delete
extension Database {
  
  func insert(city: City, at index: Int) {
    self.cities.insert(city, at: index)
    self.save(cities: self.cities)
  }
  
  func delete(at index: Int) {
    self.cities.remove(at: index)
    self.save(cities: self.cities)
  }
  
}
