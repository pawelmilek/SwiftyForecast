//
//  WebServiceError.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/06/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

enum WebServiceError: ErrorHandleable {
  case unknownURL(url: String)
  case requestFailed
  case dataNotAvailable
  case decodeFailed
  case failedToRetrieveContext
}


// MARK: - ErrorHandleable protocol
extension WebServiceError {
  
  var description: String {
    switch self {
    case .unknownURL(url: let url):
      return url
      
    case .requestFailed:
      return "An error occurred while fetching JSON data."
      
    case .dataNotAvailable:
      return "Data not available."
      
    case .decodeFailed:
      return "An error occurred while decoding data."
      
    case .failedToRetrieveContext:
      return "Failed to retrieve context."
    }
  }
  
}
