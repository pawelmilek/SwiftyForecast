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
  @NSManaged var postalCode: String?
  @NSManaged var coordinate: Coordinate
  
  convenience init(place: GMSPlace, managedObjectContext: NSManagedObjectContext) {
    self.init(context: managedObjectContext)
    
    let addressComponents = place.addressComponents
    
    self.name = addressComponents?.first(where: {$0.type == "locality"})?.name ?? place.name
    self.country = addressComponents?.first(where: {$0.type == "country"})?.name ?? "N/A"
    self.state = addressComponents?.first(where: {$0.type == "administrative_area_level_1"})?.name
    self.postalCode = addressComponents?.first(where: {$0.type == "postal_code"})?.name
    self.coordinate = Coordinate(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, managedObjectContext: managedObjectContext)
  }
}


// MARK: - Create fetch request
extension City {
  
  class func createFetchRequest() -> NSFetchRequest<City> {
    return NSFetchRequest<City>(entityName: City.entityName)
  }
  
}
