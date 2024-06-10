//
//  GeocoderError.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

enum GeocoderError: LocalizedError {
    case coordinateNotFound
    case placemarkNotFound
    case locationDisabled
    case timezoneNotFound
}

// MARK: - ErrorHandleable protocol
extension GeocoderError {

    var errorDescription: String? {
        switch self {
        case .coordinateNotFound:
            return "Geocoder failed to find a coordinate."

        case .placemarkNotFound:
            return "Geocoder failed to find a placemark."

        case .locationDisabled:
            return "Location disabled. Please, check settings."

        case .timezoneNotFound:
            return "Geocoder did not find a timezone."
        }
    }

}
