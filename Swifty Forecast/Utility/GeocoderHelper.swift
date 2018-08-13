//
//  GeocoderHelper.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 29/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

final class GeocoderHelper {
  
  class func findCoordinate(by address: String, completionHandler: @escaping (_ coordinate: Coordinate?, _ error: Error?) -> ()) {
    let geocoder = CLGeocoder()
    
    geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
      guard let placemark = placemarks?.last, error == nil else {
        completionHandler(nil, error)
        return
      }
      
      let location = placemark.location
      let coordinate = location!.coordinate
      let latitude = coordinate.latitude
      let longitude = coordinate.longitude
      
      
      let coord = Coordinate(latitude: latitude, longitude: longitude)
      completionHandler(coord, nil)
    })
  }
  
  
  class func findTimezone(at coordinate: Coordinate, completionHandler: @escaping (TimeZone?, Error?) -> ()) {
    let location = CLLocation(latitude: CLLocationDegrees(coordinate.latitude), longitude: CLLocationDegrees(coordinate.longitude))
    let geocoder = CLGeocoder()
    
    geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
      guard let placemark = placemarks?.first, error == nil else {
        completionHandler(nil, error)
        return
      }
      
      let timezone = placemark.timeZone
      completionHandler(timezone, nil)
    })
  }
}
