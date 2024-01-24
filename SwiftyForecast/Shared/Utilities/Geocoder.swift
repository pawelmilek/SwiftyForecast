//
//  Geocoder.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

final class Geocoder {
    class func fetchPlacemark(at location: CLLocation) async throws -> CLPlacemark {
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(location)

        if let placemark = placemarks.first {
            return placemark
        } else {
            throw GeocoderError.placemarkNotFound
        }
    }
}
