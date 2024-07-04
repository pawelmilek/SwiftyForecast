//
//  AboutAnalyticsEvent.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 7/3/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

public enum AboutAnalyticsEvent {
    case rowTapped(title: String)
    case screenViewed(className: String)

    public var name: String {
        switch self {
        case .rowTapped:
            "about_row_tapped"
        case .screenViewed:
            "screen_view"
        }
    }
    public var metadata: [String: Any] {
        switch self {
        case .rowTapped(let title):
            [
                "row_title": title
            ]

        case .screenViewed(let className):
            [
                "screen_name": "About Screen",
                "screen_class": className
            ]
        }
    }
}
