//
//  City.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import GooglePlaces

struct City {
  var name: String
  var country: String
  var state: String
  var zipcode: String
  var coordinate: Coordinate
}

extension City {
  
  init(addressComponents: [GMSAddressComponent]?, coordinate: Coordinate) {
    let name = addressComponents?.first(where: {$0.type == "locality"})?.name ?? ""
    let state = addressComponents?.first(where: {$0.type == "administrative_area_level_1"})?.name ?? ""
    let country = addressComponents?.first(where: {$0.type == "country"})?.name ?? ""
    let postalCode = addressComponents?.first(where: {$0.type == "postal_code"})?.name ?? ""
    
    self.init(name: name, country: country, state: state, zipcode: postalCode, coordinate: coordinate)
  }
}
