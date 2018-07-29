//
//  City.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import GooglePlaces
import CoreData

final class City: NSManagedObject {
  @NSManaged var name: String
  @NSManaged var country: String
  @NSManaged var state: String?
  @NSManaged var postalCode: String
  @NSManaged var coordinate: Coordinate
  
  convenience init(place: GMSPlace, managedObjectContext: NSManagedObjectContext) {
    self.init(context: managedObjectContext)
    
    let addressComponents = place.addressComponents
    
    self.name = addressComponents?.first(where: {$0.type == "locality"})?.name ?? place.name
    self.country = addressComponents?.first(where: {$0.type == "country"})?.name ?? "N/A"
    self.state = addressComponents?.first(where: {$0.type == "administrative_area_level_1"})?.name
    self.postalCode = addressComponents?.first(where: {$0.type == "postal_code"})?.name ?? "N/A"
    self.coordinate = Coordinate(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, managedObjectContext: managedObjectContext)
  }
  
  convenience init(unassociatedObject: City, managedObjectContext: NSManagedObjectContext) {
    self.init(context: managedObjectContext)
    
    self.name = unassociatedObject.name
    self.country = unassociatedObject.country
    self.state = unassociatedObject.state
    self.postalCode = unassociatedObject.postalCode
    
    let latitude = unassociatedObject.coordinate.latitude
    let longitude = unassociatedObject.coordinate.longitude
    self.coordinate = Coordinate(latitude: latitude, longitude: longitude, managedObjectContext: managedObjectContext)
  }
  
  
  convenience init(place: GMSPlace) {
    let entity = NSEntityDescription.entity(forEntityName: City.entityName, in: ManagedObjectContextHelper.shared.mainContext)!
    self.init(entity: entity, insertInto: nil)
    
    let addressComponents = place.addressComponents
    
    self.name = addressComponents?.first(where: {$0.type == "locality"})?.name ?? place.name
    self.country = addressComponents?.first(where: {$0.type == "country"})?.name ?? "N/A"
    self.state = addressComponents?.first(where: {$0.type == "administrative_area_level_1"})?.name
    self.postalCode = addressComponents?.first(where: {$0.type == "postal_code"})?.name ?? "N/A"
    self.coordinate = Coordinate(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
  }
}


// MARK: - Is city exists
extension City {
  
  var isExists: Bool {
    guard let context = managedObjectContext else {
      CoreDataError.notAssociatedWithManagedObjectContext(entityName: City.entityName).handle()
      return false
    }
    
    let request = City.createFetchRequest()
    let predicate = NSPredicate(format: "name == %@ AND country == %@ AND coordinate == %@", name, country, coordinate)
    
    request.predicate = predicate
    
    do {
      let count = try context.count(for: request)
      if count == NSNotFound {
        return false
      } else {
        return true
      }
      
    } catch {
      CoreDataError.entityNotFound.handle()
      return false
    }
  }
  
  
  class func isDuplicate(city: City) -> Bool {
    let request = City.createFetchRequest()
    let predicate = NSPredicate(format: "name == %@ && country == %@ && postalCode == %@", city.name, city.country, city.postalCode)
    request.predicate = predicate
    
    do {
      let result = try ManagedObjectContextHelper.shared.mainContext.fetch(request)
      if result.count > 0 {
        return true
      } else {
        return false
      }
    } catch {
      CoreDataError.couldNotFetch.handle()
      return false
    }
  }
  
}


// MARK: - Create fetch request
extension City {
  
  class func createFetchRequest() -> NSFetchRequest<City> {
    return NSFetchRequest<City>(entityName: City.entityName)
  }
  
  class func clone(city: City) {
    
  }
  
}
