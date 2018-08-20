//
//  GooglePlacesHelper.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 15/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation
import GooglePlaces

struct GooglePlacesHelper {
  static private let sharedPlacesClient = GMSPlacesClient.shared()
}


// MARK: - Get current place
extension GooglePlacesHelper {
  
  static func getCurrentPlace(completionHandler: @escaping (_ place: GMSPlace?, _ error: Error?) -> ()) {
    guard LocationProvider.shared.isLocationServicesEnabled else {
      let locationError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Please enable location."])
      completionHandler(nil, locationError)
      return
    }
    
    sharedPlacesClient.currentPlace() { (placeLikelihoodList, error) in
      if error == nil {
        let place = placeLikelihoodList?.likelihoods.first?.place
        completionHandler(place, nil)

      } else {
        completionHandler(nil, error)
      }
    }
  }
  
}
