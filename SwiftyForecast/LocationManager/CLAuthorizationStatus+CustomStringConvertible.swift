//
//  CLAuthorizationStatus+CustomStringConvertible.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 12/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

extension CLAuthorizationStatus: CustomStringConvertible {
    public var description: String {
        return switch self {
        case .notDetermined:  "Not Determined"
        case .authorizedWhenInUse: "Authorized When In Use"
        case .authorizedAlways: "Authorized Always"
        case .restricted: "Restricted"
        case .denied: "Denied"
        @unknown default: "Unknown"
        }
    }
}
