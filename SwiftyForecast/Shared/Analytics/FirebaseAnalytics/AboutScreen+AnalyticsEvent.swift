//
//  AboutScreen+AnalyticsEvent.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

extension AnalyticsEvent {
    static func aboutRowTapped(title: String) -> AnalyticsEvent {
        AnalyticsEvent(name: "about_row_tapped", metadata: ["row_title": title])
    }
}
