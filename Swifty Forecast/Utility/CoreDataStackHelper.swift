//
//  CoreDataStackHelper.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 18/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataStackHelper {
  static let shared = CoreDataStackHelper()
  
  private var appDelegate: AppDelegate
  let mainContext: NSManagedObjectContext
  
  
  private init() {
    self.appDelegate = UIApplication.shared.delegate as! AppDelegate
    self.mainContext = self.appDelegate.persistentContainer.viewContext
  }
}
