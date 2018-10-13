//
//  LocalizedCityManager.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 10/09/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

final class LocalizedCityManager {
  static private let sharedStack = CoreDataStackHelper.shared
  
  
  static func deleteCurrentLocalizedCity() {
    let request = City.createFetchRequest()
    let predicate = NSPredicate(format: "isCurrentLocalization == %@", NSNumber(value: true))
    request.predicate = predicate
    
    if let cities = try? sharedStack.managedContext.fetch(request) {
      for city in cities {
        sharedStack.managedContext.delete(city)
      }
      
      sharedStack.saveContext()
    }
  }
  
  
  static func insertCurrentLocalized(city: City) {
    let _ = City(unassociatedObject: city, isCurrentLocalization: true, managedObjectContext: sharedStack.managedContext)
  }
  
  
  static func fetchAndResetLocalizedCities() {
    let fetchRequest = City.createFetchRequest()
    if let cities = try? sharedStack.managedContext.fetch(fetchRequest) {
      cities.forEach {
        $0.isCurrentLocalization = false
      }
    }
  }
  
  
  static func updateCurrentLocalized(city: City) {
    let request = City.createFetchRequest()
    let predicate = NSPredicate(format: "name == %@ && country == %@", city.name, city.country)
    request.predicate = predicate
    
    if let city = try? sharedStack.managedContext.fetch(request) {
      city.forEach {
        $0.isCurrentLocalization = true
      }
    }
    
    sharedStack.saveContext()
  }
  
  
  static func fetchCurrentCity() -> City? {
    let request = City.createFetchRequest()
    let predicate = NSPredicate(format: "isCurrentLocalization == %@", NSNumber(value: true))
    request.predicate = predicate
    
    if let cities = try? sharedStack.managedContext.fetch(request) {
      return cities.first
    }
    
    return nil
  }
  
  
  static func checkIfPerformForecastFetch(for city: City) -> Bool {
    let request = City.createFetchRequest()
    let predicate = NSPredicate(format: "name == %@ && country == %@", city.name, city.country)
    request.predicate = predicate
    
    var updateForecast = false
    let fiveMinutesInterval: Double = 60 * 1
    
    if let city = try? sharedStack.managedContext.fetch(request) {
      if let city = city.first, let lastUpdate = city.lastUpdate {
        let timeInterval = Date().timeIntervalSince(lastUpdate)
        if (timeInterval >= fiveMinutesInterval) {
          updateForecast = true
        } else {
          updateForecast = false
        }
      }
    }
    
    return updateForecast
    
  }
  
}
