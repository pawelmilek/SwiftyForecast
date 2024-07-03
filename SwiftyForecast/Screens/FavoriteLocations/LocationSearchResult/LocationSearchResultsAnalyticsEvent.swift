//
//  LocationSearchResultsAnalyticsEvent.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 7/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct LocationSearchResultsAnalyticsEvent: AnalyticsEvent {
    private enum Names {
        static let screenViewed = "screen_view"
    }

    let name: String
    let metadata: [String: Any]

    init(name: String, metadata: [String: Any]) {
        self.name = name
        self.metadata = metadata
    }
}

extension LocationSearchResultsAnalyticsEvent {
    static func screenViewed(name: String, className: String) -> ScreenAnalyticsEvent {
        ScreenAnalyticsEvent(
            name: Names.screenViewed,
            metadata: [
                "screen_name": name,
                "screen_class": className
            ]
        )
    }
}
