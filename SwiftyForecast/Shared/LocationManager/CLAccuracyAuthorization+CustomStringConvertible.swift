//
//  CLAccuracyAuthorization+CustomStringConvertible.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 12/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//
//swiftlint:disable switch_case_alignment

import Foundation
import CoreLocation

extension CLAccuracyAuthorization: CustomStringConvertible {
    public var description: String {
        return switch self {
        case .fullAccuracy: "Full Accuracy"
        case .reducedAccuracy: "Reduced Accuracy"
        @unknown default: "Unknown"
        }
    }
}
