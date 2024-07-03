//
//  LocationWeatherViewEvent.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct LocationWeatherViewEvent: AnalyticsEvent {
    private enum Names {
        static let locationAdded = "new_location_added"
        static let screenViewed = "screen_view"
    }

    let name: String
    let metadata: [String: Any]

    init(name: String, metadata: [String: Any]) {
        self.name = name
        self.metadata = metadata
    }
}

extension LocationWeatherViewEvent {
    static func locationAdded(name: String) -> LocationWeatherViewEvent {
        LocationWeatherViewEvent(
            name: Names.locationAdded,
            metadata: ["location": name]
        )
    }

    static func screenViewed(name: String, className: String) -> LocationWeatherViewEvent {
        LocationWeatherViewEvent(
            name: Names.screenViewed,
            metadata: [
                "screen_name": name,
                "screen_class": className
            ]
        )
    }
}
