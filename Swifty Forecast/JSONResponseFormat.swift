//
//  JSONResponseFormat.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 28/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation


struct JSONResponseFormat {
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let currently = "currently"
    static let hourly = "hourly"
    static let daily = "daily"
    static let data = "data"
    
    struct DataPoint {
        static let time = "time"
        static let icon = "icon"
        static let summary = "summary"
        static let moonPhase = "moonPhase"
        static let temperature = "temperature"
        static let temperatureMin = "temperatureMin"
        static let temperatureMax = "temperatureMax"
    }
}
