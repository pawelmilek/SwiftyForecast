//
//  Geocoder.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

protocol GeocodeLocationProtocol {
    func requestPlacemark(at location: CLLocation) async throws -> CLPlacemark
}

final class GeocodeLocation: GeocodeLocationProtocol {
    private let geocoder: CLGeocoder

    init(geocoder: CLGeocoder) {
        self.geocoder = geocoder
    }

    func requestPlacemark(at location: CLLocation) async throws -> CLPlacemark {
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        if let placemark = placemarks.first {
            return placemark
        } else {
            throw GeocoderError.placemarkNotFound
        }
    }
}
