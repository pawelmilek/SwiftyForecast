//
//  CoreDataManager.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 10/09/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

final class CoreDataManager {
  static private let sharedMOC = CoreDataStackHelper.shared
  
  
  static func deleteCurrentLocalizedCity() {
    let request = City.createFetchRequest()
    let predicate = NSPredicate(format: "isCurrentLocalized == %@", NSNumber(value: true))
    request.predicate = predicate
    
    if let cities = try? sharedMOC.mainContext.fetch(request) {
      for city in cities {
        sharedMOC.mainContext.delete(city)
      }
      
      do {
        try sharedMOC.mainContext.save()
      } catch {
        CoreDataError.couldNotSave.handle()
      }
    }
  }
  
  
  static func insertCurrentLocalized(city: City) {
    let _ = City(unassociatedObject: city, isCurrentLocalized: true, managedObjectContext: sharedMOC.mainContext)
  }
  
  
  static func fetchAndResetLocalizedCities() {
    let fetchRequest = City.createFetchRequest()
    if let cities = try? sharedMOC.mainContext.fetch(fetchRequest) {
      cities.forEach {
        $0.isCurrentLocalized = false
      }
    }
  }
  
  
  static func updateCurrentLocalized(city: City) {
    let request = City.createFetchRequest()
    let predicate = NSPredicate(format: "name == %@ && country == %@", city.name, city.country)
    request.predicate = predicate
    
    if let city = try? sharedMOC.mainContext.fetch(request) {
      city.forEach {
        $0.isCurrentLocalized = true
      }
    }
    
    do {
      try sharedMOC.mainContext.save()
    } catch {
      CoreDataError.couldNotSave.handle()
    }
  }
  
}
