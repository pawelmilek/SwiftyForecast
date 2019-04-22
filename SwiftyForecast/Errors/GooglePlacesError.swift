//
//  GooglePlacesError.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 26/08/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

enum GooglePlacesError: ErrorHandleable {
  case placeNotFound
  case locationDisabled
}


// MARK: - ErrorHandleable protocol
extension GooglePlacesError {
  
  var description: String {
    switch self {
    case .placeNotFound:
      return "Google Places did not find a place."
      
    case .locationDisabled:
      return "Location disabled. Please, check settings."
    }
  }
  
}
