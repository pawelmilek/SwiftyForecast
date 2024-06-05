//
//  MainViewController+AnalyticsEvent.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

extension AnalyticsEvent {
    static func temperatureNotationSwitched(notation: String) -> AnalyticsEvent {
        AnalyticsEvent(name: "temperature_notation_switched", metadata: ["temperature_notation": notation])
    }
}
