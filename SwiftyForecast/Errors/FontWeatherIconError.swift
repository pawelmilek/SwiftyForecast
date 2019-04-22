//
//  FontWeatherIconError.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 10/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

enum FontWeatherIconError: ErrorHandleable {
  case fileNotFound(name: String)
  case unknownFontURL(urlString: String)
  case fontDataFailed
  case fontRegistrationFailed(description: String)
}


// MARK: - ErrorHandleable protocol
extension FontWeatherIconError {
  
  var description: String {
    switch self {
    case .fileNotFound(let name):
      return "Font file not found \(name)."
      
    case .unknownFontURL(let urlString):
      return "Font URL \(urlString) failed."
      
    case .fontDataFailed:
      return "An error occurred while creating font data."
      
    case .fontRegistrationFailed(let desc):
      return desc
    }
  }
  
}
