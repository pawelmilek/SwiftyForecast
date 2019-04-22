//
//  NSManagedObject+EntityName.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 18/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
  
  static var entityName: String {
    return "\(self)"
  }
  
}


extension NSManagedObject {
  
  convenience init(managedObjectContext: NSManagedObjectContext) {
    let entityName = type(of: self).entityName
    let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)!
    self.init(entity: entity, insertInto: managedObjectContext)
  }
  
}
