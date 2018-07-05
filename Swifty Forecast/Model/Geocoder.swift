//
//  Geocoder.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 29/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

final class Geocoder {
  
  class func findCoordinate(by address: String, completionHandler: @escaping (Coordinate) -> ()) {
    let geocoder = CLGeocoder()
    
    geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
      guard let placemarks = placemarks, !placemarks.isEmpty, error == nil else { return }
      let placemark = placemarks.last
      let location = placemark?.location
      let coordinate = location!.coordinate
      let latitude = coordinate.latitude
      let longitude = coordinate.longitude
      
      let coord = Coordinate(latitude: latitude, longitude: longitude)
      completionHandler(coord)
    })
  }
  
  
  class func findCity(at coordinate: Coordinate, completionHandler: @escaping (City) -> ()) {
    let location = CLLocation(latitude: CLLocationDegrees(coordinate.latitude), longitude: CLLocationDegrees(coordinate.longitude))
    let geocoder = CLGeocoder()
    
    geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
      guard let placemarks = placemarks, !placemarks.isEmpty, error == nil else { return }
      let placemark = placemarks.last
      let cityName = placemark?.locality ?? ""
      let country = placemark?.country ?? ""
      let lat = location.coordinate.latitude
      let long = location.coordinate.longitude
      
      let coordinate = Coordinate(latitude: lat, longitude: long)
      let city = City(name: cityName, country: country, coordinate: coordinate)
      completionHandler(city)
      
    })
  }
}
