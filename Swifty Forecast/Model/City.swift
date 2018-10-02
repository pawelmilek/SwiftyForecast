//
//  City.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 26/09/18.
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
  @NSManaged var isCurrentLocalized: Bool
  @NSManaged var coordinate: Coordinate
  @NSManaged var timeZone: TimeZone?
  
  convenience init(place: GMSPlace, isCurrentLocalized: Bool, managedObjectContext: NSManagedObjectContext) {
    self.init(context: managedObjectContext)
    
    let addressComponents = place.addressComponents
    
    self.name = addressComponents?.first(where: {$0.type == "locality"})?.name ?? place.name
    self.country = addressComponents?.first(where: {$0.type == "country"})?.name ?? "N/A"
    self.state = addressComponents?.first(where: {$0.type == "administrative_area_level_1"})?.name ?? "N/A"
    self.postalCode = addressComponents?.first(where: {$0.type == "postal_code"})?.name ?? "N/A"
    self.isCurrentLocalized = isCurrentLocalized
    self.coordinate = Coordinate(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, managedObjectContext: managedObjectContext)
  }
  
  convenience init(unassociatedObject: City, isCurrentLocalized: Bool, managedObjectContext: NSManagedObjectContext) {
    self.init(context: managedObjectContext)
    
    self.name = unassociatedObject.name
    self.country = unassociatedObject.country
    self.state = unassociatedObject.state
    self.postalCode = unassociatedObject.postalCode
    self.isCurrentLocalized = isCurrentLocalized
    
    let latitude = unassociatedObject.coordinate.latitude
    let longitude = unassociatedObject.coordinate.longitude
    self.coordinate = Coordinate(latitude: latitude, longitude: longitude, managedObjectContext: managedObjectContext)
  }
  
  
  convenience init(place: GMSPlace) {
    let entity = NSEntityDescription.entity(forEntityName: City.entityName, in: CoreDataStackHelper.shared.mainContext)!
    self.init(entity: entity, insertInto: nil)
    
    let addressComponents = place.addressComponents
    
    self.name = addressComponents?.first(where: {$0.type == "locality"})?.name ?? place.name
    self.country = addressComponents?.first(where: {$0.type == "country"})?.name ?? "N/A"
    self.state = addressComponents?.first(where: {$0.type == "administrative_area_level_1"})?.name
    self.postalCode = addressComponents?.first(where: {$0.type == "postal_code"})?.name ?? "N/A"
    self.isCurrentLocalized = false
    self.coordinate = Coordinate(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
  }
}


// MARK: - Local time
extension City {
  
  var localTime: String {
    guard let timezone = self.timeZone else { return "N/A" }
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    formatter.timeZone = timezone
    
    let localTime = formatter.string(from: Date())
    return localTime
  }
  
}


// MARK: - Create fetch request
extension City {
  
  class func createFetchRequest() -> NSFetchRequest<City> {
    return NSFetchRequest<City>(entityName: City.entityName)
  }
  
}


// MARK: - Is city exists
extension City {
  
  class func isExists(city: City) -> Bool {
    let request = City.createFetchRequest()
    let predicate = NSPredicate(format: "name == %@ && country == %@", city.name, city.country)
    request.predicate = predicate
    
    do {
      let result = try CoreDataStackHelper.shared.mainContext.fetch(request)
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
