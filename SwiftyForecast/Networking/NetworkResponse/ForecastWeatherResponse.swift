//
//  ForecastWeatherResponse.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/12/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

struct ForecastWeatherResponse: Codable {
    let data: [ForecastData]

    enum CodingKeys: String, CodingKey {
        case data = "list"
    }
}

// MARK: - ForecastData
struct ForecastData: Codable {
    let dateTimeUnix: Int
    let main: Main
    let conditions: [Condition]
    let cloudCoverage: CloudCoverage
    let wind: Wind
    let probabilityOfPrecipitation: Double
    let partOfDay: Sys

    enum CodingKeys: String, CodingKey {
        case dateTimeUnix = "dt"
        case main
        case conditions = "weather"
        case cloudCoverage = "clouds"
        case wind
        case probabilityOfPrecipitation = "pop"
        case partOfDay = "sys"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: DayNightState
}
