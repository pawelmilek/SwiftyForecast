//
//  CoreDataStackHelper.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 18/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStackHelper {
  static let shared = CoreDataStackHelper()
  private let stack: CoreDataStack
  
  private init() {
    self.stack = CoreDataStack(modelName: "SwiftyForecast")
  }
  
  
  var managedContext: NSManagedObjectContext {
    return stack.managedContext
  }
  
//  var savingContext: NSManagedObjectContext {
//    return stack.savingContext
//  }
  
  func saveContext() {
    stack.saveContext()
  }
}
