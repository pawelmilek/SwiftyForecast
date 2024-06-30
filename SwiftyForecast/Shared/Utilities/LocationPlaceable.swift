//
//  LocationPlaceable.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/30/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import CoreLocation

protocol LocationPlaceable {
    func placemark(at location: CLLocation) async throws -> CLPlacemark
}
