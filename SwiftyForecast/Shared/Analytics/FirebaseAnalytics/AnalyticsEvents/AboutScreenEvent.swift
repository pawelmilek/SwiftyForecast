//
//  AboutScreenEvent.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct AboutScreenEvent: AnalyticsEvent {
    private enum Names {
        static let rowTapped = "about_row_tapped"
    }

    let name: String
    let metadata: [String: Any]

    init(name: String, metadata: [String: Any]) {
        self.name = name
        self.metadata = metadata
    }
}

extension AboutScreenEvent {
    static func rowTapped(title: String) -> AboutScreenEvent {
        AboutScreenEvent(
            name: Names.rowTapped,
            metadata: [
                "row_title": title
            ]
        )
    }
}
