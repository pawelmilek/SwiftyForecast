//
//  Coordinate.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 27/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import CoreData

final class Coordinate: NSManagedObject, Decodable {
  private enum CodingKeys: String, CodingKey {
    case latitude
    case longitude
  }
  
  @NSManaged var latitude: Double
  @NSManaged var longitude: Double
  
  required convenience init(from decoder: Decoder) throws {
    guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
      let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
      let entity = NSEntityDescription.entity(forEntityName: Coordinate.entityName, in: managedObjectContext) else {
        fatalError("Failed to decode Coordinate")
    }

    self.init(entity: entity, insertInto: nil)

    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.latitude = try container.decode(Double.self, forKey: .latitude)
    self.longitude = try container.decode(Double.self, forKey: .longitude)
  }
}


// MARK: - Convenience initializer
extension Coordinate {

  convenience init(latitude: Double, longitude: Double, managedObjectContext: NSManagedObjectContext) {
    let entity = NSEntityDescription.entity(forEntityName: Coordinate.entityName, in: managedObjectContext)!
    self.init(entity: entity, insertInto: managedObjectContext)

    self.latitude = latitude
    self.longitude = longitude
  }
  
  convenience init(latitude: Double, longitude: Double) {
    let entity = NSEntityDescription.entity(forEntityName: Coordinate.entityName, in: ManagedObjectContextHelper.shared.mainContext)!
    self.init(entity: entity, insertInto: nil)
    
    self.latitude = latitude
    self.longitude = longitude
  }
  
}


// MARK: - Create fetch request
extension Coordinate {
  
  class func createFetchRequest() -> NSFetchRequest<Coordinate> {
    return NSFetchRequest<Coordinate>(entityName: Coordinate.entityName)
  }
  
}
