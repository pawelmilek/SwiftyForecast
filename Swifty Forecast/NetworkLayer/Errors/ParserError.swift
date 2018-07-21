//
//  ParserError.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 18/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

enum ParserError: ErrorHandleable {
  case decodeFailed
  case failedToRetrieveContext
}

// MARK: - ErrorHandleable protocol
extension ParserError {
  
  var description: String {
    switch self {
    case .decodeFailed:
      return "An error occurred while decoding data."
      
    case .failedToRetrieveContext:
      return "Failed to retrieve context."
    }
  }
  
}
