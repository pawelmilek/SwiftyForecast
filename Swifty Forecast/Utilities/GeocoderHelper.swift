//
//  GeocoderHelper.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 29/09/18.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

final class GeocoderHelper {
  
  class func findCoordinate(by address: String, completionHandler: @escaping (_ coordinate: CLLocationCoordinate2D?, _ error: GeocoderError?) -> ()) {
    let geocoder = CLGeocoder()
    
    geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
      guard let placemark = placemarks?.last, error == nil else {
        completionHandler(nil, GeocoderError.coordinateNotFound)
        return
      }
      
      let location = placemark.location
      let coordinate = location?.coordinate
      
      completionHandler(coordinate, nil)
    })
  }
  
  
  class func findPlace(at coordinate: CLLocationCoordinate2D, completionHandler: @escaping (_ placemark: CLPlacemark?, _ error: GeocoderError?) -> ()) {
    let location = CLLocation(latitude: CLLocationDegrees(coordinate.latitude), longitude: CLLocationDegrees(coordinate.longitude))
    let geocoder = CLGeocoder()
    
    geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
      guard let placemark = placemarks?.first, error == nil else {
        completionHandler(nil, GeocoderError.placeNotFound)
        return
      }
      
      completionHandler(placemark, nil)
    })
  }
  
  
  class func findTimeZone(at coordinate: CLLocationCoordinate2D, completionHandler: @escaping (TimeZone?, GeocoderError?) -> ()) {
    let location = CLLocation(latitude: CLLocationDegrees(coordinate.latitude), longitude: CLLocationDegrees(coordinate.longitude))
    let geocoder = CLGeocoder()
    
    geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
      guard let placemark = placemarks?.first, error == nil else {
        completionHandler(nil, GeocoderError.timezoneNotFound)
        return
      }
      
      let timezone = placemark.timeZone
      completionHandler(timezone, nil)
    })
  }
}
