//
//  AppearanceView+AnalyticsEvent.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

extension AnalyticsEvent {
    static func colorSchemeSwitched(name: String) -> AnalyticsEvent {
        AnalyticsEvent(name: "color_Scheme_Switched", metadata: ["color_scheme": name])
    }
}
