//
//  GeocodedLocation.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationPlaceable {
    func placemark(at location: CLLocation) async throws -> CLPlacemark
}

final class GeocodedLocation: LocationPlaceable {
    private let geocoder: CLGeocoder

    init(geocoder: CLGeocoder) {
        self.geocoder = geocoder
    }

    @MainActor
    func placemark(at location: CLLocation) async throws -> CLPlacemark {
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        if let placemark = placemarks.first {
            return placemark
        } else {
            throw GeocoderError.placemarkNotFound
        }
    }
}
