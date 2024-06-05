//
//  View+AnalyticsEvent.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

extension AnalyticsEvent {
    static func screenViewed(name: String, className: String) -> AnalyticsEvent {
        AnalyticsEvent(name: "screen_view", metadata: ["screen_name": name, "screen_class": className])
    }
}
