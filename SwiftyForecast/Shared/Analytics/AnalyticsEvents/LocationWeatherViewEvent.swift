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
        static let newLocationAdded = "new_location_added"
    }

    let name: String
    let metadata: [String: Any]

    init(name: String, metadata: [String: Any]) {
        self.name = name
        self.metadata = metadata
    }
}

extension LocationWeatherViewEvent {
    static func newLocationAdded(name: String) -> LocationWeatherViewEvent {
        LocationWeatherViewEvent(
            name: Names.newLocationAdded,
            metadata: ["location": name]
        )
    }
}
