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
  
  
  class func findCity(at coordinate: Coordinate, completionHandler: @escaping (City?, Error?) -> ()) {
    let location = CLLocation(latitude: CLLocationDegrees(coordinate.latitude), longitude: CLLocationDegrees(coordinate.longitude))
    let geocoder = CLGeocoder()
    
    geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
      guard let placemark = placemarks?.last, error == nil else {
        completionHandler(nil, error)
        return
      }
      
      let cityName = placemark.locality!
      let country = placemark.country!
      let postalCode = placemark.postalCode
      let lat = location.coordinate.latitude
      let long = location.coordinate.longitude
      
      let coordinate = Coordinate(latitude: lat, longitude: long)
      let city = City(name: cityName, country: country, state: "IL", zipcode: postalCode!, coordinate: coordinate)
      completionHandler(city, nil)
      
    })
  }
}
