//
//  NewCityControllerDelegate.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation


protocol NewCityControllerDelegate: class {
  
  func newCityControllerDidAdd(_ newCityController: NewCityController, city: City)
  func newContactViewControllerDidCancel(_ newCityController: NewCityController)
  
}
