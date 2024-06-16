//
//  CurrentWeatherResponse.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/12/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct CurrentWeatherResponse: Codable {
    let identifier: Int
    let name: String
    let timezone: Int
    let coordinate: Coordinate
    let conditions: [Condition]
    let main: Main
    let wind: Wind
    let cloudCoverage: CloudCoverage
    let dateTimeUnix: Int
    let metadata: Metadata

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case timezone
        case coordinate = "coord"
        case conditions = "weather"
        case main
        case wind
        case cloudCoverage = "clouds"
        case dateTimeUnix = "dt"
        case metadata = "sys"
    }
}

// MARK: - Metadata
struct Metadata: Codable {
    let country: String
    let sunrise: Int
    let sunset: Int

    enum CodingKeys: String, CodingKey {
        case country
        case sunrise
        case sunset
    }
}
