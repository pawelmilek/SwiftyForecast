//
//  ThemeViewEvent.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct ThemeViewEvent: AnalyticsEvent {
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

extension ThemeViewEvent {
    static func colorSchemeSwitched(name: String) -> ThemeViewEvent {
        ThemeViewEvent(
            name: Names.colorSchemeSwitched,
            metadata: [
                "color_scheme": name
            ]
        )
    }
}
