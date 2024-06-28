//
//  LocationListEvent.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct LocationListEvent: AnalyticsEvent {
    private enum Names {
        static let locationSelected = "location_selected"
    }

    let name: String
    let metadata: [String: Any]

    init(name: String, metadata: [String: Any]) {
        self.name = name
        self.metadata = metadata
    }
}

extension LocationListEvent {
    static func locationSelected(name: String) -> LocationListEvent {
        LocationListEvent(
            name: Names.locationSelected,
            metadata: [
                "location_selected": name
            ]
        )
    }
}
