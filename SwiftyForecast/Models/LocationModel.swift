//
//  LocationModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift

class LocationModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var compoundKey = "name|country"
    @Persisted var name = ""
    @Persisted var country = ""
    @Persisted var state = ""
    @Persisted var postalCode = ""
    @Persisted var secondsFromGMT = 0
    @Persisted var latitude = 0.0
    @Persisted var longitude = 0.0
    @Persisted var lastUpdate = Date()
    @Persisted var isUserLocation = false

    convenience init(placemark: CLPlacemark, isUserLocation: Bool = false) {
        self.init()
        name = placemark.locality ?? InvalidReference.notApplicable
        country = placemark.country ?? InvalidReference.notApplicable
        compoundKey = "\(name)|\(country)"
        state = placemark.administrativeArea ?? InvalidReference.notApplicable
        postalCode = placemark.postalCode ?? InvalidReference.notApplicable
        latitude = placemark.location?.coordinate.latitude ?? Double.nan
        longitude = placemark.location?.coordinate.longitude ?? Double.nan
        secondsFromGMT = placemark.timeZone?.secondsFromGMT() ?? Int.min
        self.isUserLocation = isUserLocation
    }
}

// MARK: - example data
extension LocationModel {
    static let examples = [
        LocationModel(
            value: [
                "compoundKey": "Rzeszów|Poland",
                "name": "Rzeszów",
                "country": "Poland",
                "state": "Subcarpathian",
                "postalCode": "35-512",
                "secondsFromGMT": 3600,
                "latitude": 50.060868,
                "longitude": 21.970219,
                "lastUpdate": Date(),
                "isUserLocation": 1
            ]
        ),
        LocationModel(
            value: [
                "compoundKey": "Chicago|United States",
                "name": "Chicago",
                "country": "United States",
                "state": "IL",
                "postalCode": "60602",
                "secondsFromGMT": -21600,
                "latitude": 41.883718,
                "longitude": -87.632382,
                "lastUpdate": Date(),
                "isUserLocation": 0
            ]
        ),
        LocationModel(
            value: [
                "compoundKey": "San Francisco|United States",
                "name": "San Francisco",
                "country": "United States",
                "state": "CA",
                "postalCode": "94102",
                "secondsFromGMT": -28800,
                "latitude": 37.779379,
                "longitude": 122.418433,
                "lastUpdate": Date(),
                "isUserLocation": 0
            ]
        )
    ]
}
