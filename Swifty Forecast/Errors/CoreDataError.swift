//
//  CoreDataError.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 18/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

enum CoreDataError: ErrorHandleable {
  case entityNotFound
  case couldNotSave
  case couldNotFetch
  case notAssociatedWithManagedObjectContext(entityName: String)
}


// MARK: - ErrorHandleable protocol
extension CoreDataError {
  
  var description: String {
    switch self {
    case .entityNotFound:
      return "No Entity found. Check the Entity Name."
      
    case .couldNotSave:
      return "Could not save in managed contex."
      
    case .couldNotFetch:
      return "Could not fetch from managed contex."
      
    case .notAssociatedWithManagedObjectContext(let entityName):
      return "Provided \(entityName) managed object is not associated with a managed object context."
      
    }
  }
  
}
