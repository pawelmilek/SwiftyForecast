//
//  Geocoder.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 29/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation



class Geocoder {
    
    class func getCoordinateFrom(address: String, completionBlock: @escaping (Coordinate) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) in
            guard let placemarks = placemarks, !placemarks.isEmpty, error == nil else { return }
            let placemark = placemarks.last
            let location = placemark?.location
            let coordinate = location!.coordinate
            let latitude = coordinate.latitude
            let longitude = coordinate.longitude
            
            let coord = Coordinate(latitude: latitude, longitude: longitude)
            completionBlock(coord)
        })
    }
    
    
    class func getCityFrom(latitude: Double, longitude: Double, completionBlock: @escaping (City) -> Void) {
        let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            guard let placemarks = placemarks, !placemarks.isEmpty, error == nil else { return }
            let placemark = placemarks.last
            let cityName = placemark?.locality ?? ""
            let country = placemark?.country ?? ""
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            let city = City(name: cityName, country: country, latitude: lat, longitude: long)
            completionBlock(city)
        })
    }
}
