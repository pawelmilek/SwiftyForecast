//
//  ErrorHandleable.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 26/06/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.

import Foundation

protocol ErrorHandleable: Error, CustomStringConvertible { }


// MARK: - Handle errors
extension ErrorHandleable {
  
  func handle() {
    DispatchQueue.main.async {
      AlertViewPresenter.shared.presentError(withMessage: self.description)
    }
  }
  
}
