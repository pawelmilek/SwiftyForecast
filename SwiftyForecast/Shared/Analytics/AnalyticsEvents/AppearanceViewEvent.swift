//
//  AppearanceViewEvent.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct AppearanceViewEvent: AnalyticsEvent {
    private enum Names {
        static let colorSchemeSwitched = "color_Scheme_Switched"
    }

    let name: String
    let metadata: [String: Any]

    init(name: String, metadata: [String: Any]) {
        self.name = name
        self.metadata = metadata
    }
}

extension AppearanceViewEvent {
    static func colorSchemeSwitched(name: String) -> AppearanceViewEvent {
        AppearanceViewEvent(
            name: Names.colorSchemeSwitched,
            metadata: [
                "color_scheme": name
            ]
        )
    }
}
