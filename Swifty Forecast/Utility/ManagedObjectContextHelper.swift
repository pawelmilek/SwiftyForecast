//
//  ManagedObjectContextHelper.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 18/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ManagedObjectContextHelper {
  static let shared = ManagedObjectContextHelper()
  
  private var appDelegate: AppDelegate
  var mainContext: NSManagedObjectContext
  
  
  private init() {
    self.appDelegate = UIApplication.shared.delegate as! AppDelegate
    self.mainContext = self.appDelegate.persistentContainer.viewContext
  }
}



extension ManagedObjectContextHelper {
  
  func saveContext() {
    ManagedObjectContextHelper.shared.appDelegate.saveContext()
  }
  
}
