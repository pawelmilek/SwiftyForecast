//
//  DarkSkyAPI.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation


struct DarkSkyAPI {
    static let exclude = "?exclude=minutely,alerts,flags"
    static let units = "?units=us"
    
    static var requestURL: String {
        //https://api.darksky.net/forecast/6a92402c27dfc4740168ec5c0673a760/42.3601,-71.0589?exclude=minutely,hourly,alerts,flags?units=us
        let secretKey = "6a92402c27dfc4740168ec5c0673a760"
        return "https://api.forecast.io/forecast/\(secretKey)/"
    }
}
