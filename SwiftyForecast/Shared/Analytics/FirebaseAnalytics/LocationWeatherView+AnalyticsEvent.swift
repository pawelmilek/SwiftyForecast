//
//  LocationWeatherView+AnalyticsEvent.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

extension AnalyticsEvent {
    static func newLocationAdded(name: String) -> AnalyticsEvent {
        AnalyticsEvent(name: "new_location_added", metadata: ["location": name])
    }
}
