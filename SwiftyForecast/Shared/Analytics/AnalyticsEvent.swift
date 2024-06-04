//
//  AnalyticsEvent.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

enum AnalyticsEvent {
    case colorSchemeSwitched(name: String)
    case temperatureNotationSwitched(notation: String)
    case aboutRowTapped(title: String)
    case locationSelected(name: String)
    case screenViewed(name: String, className: String)
    case newLocationAdded(name: String)

    var name: String {
        switch self {
        case .colorSchemeSwitched:
            "color_Scheme_Switched"
        case .temperatureNotationSwitched:
            "temperature_notation_switched"
        case .aboutRowTapped:
            "about_row_tapped"
        case .locationSelected:
            "location_selected"
        case .screenViewed:
            "screen_view"
        case .newLocationAdded:
            "new_location_added"
        }
    }

    var metadata: [String: String] {
        switch self {
        case .colorSchemeSwitched(let name):
            ["color_scheme": name]
        case .temperatureNotationSwitched(let notation):
            ["temperature_notation": notation]
        case .aboutRowTapped(let title):
            ["row_title": title]
        case .locationSelected(let name):
            ["location_selected": name]
        case .screenViewed(let name, let className):
            ["screen_name": name, "screen_class": className]
        case .newLocationAdded(let name):
            ["location": name]
        }
    }
}
