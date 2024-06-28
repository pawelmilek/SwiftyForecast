//
//  MainViewControllerEvent.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct MainViewControllerEvent: AnalyticsEvent {
    private enum Names {
        static let temperatureNotationSwitched = "temperature_notation_switched"
    }

    let name: String
    let metadata: [String: Any]

    init(name: String, metadata: [String: Any]) {
        self.name = name
        self.metadata = metadata
    }
}

extension MainViewControllerEvent {
    static func temperatureNotationSwitched(notation: String) -> MainViewControllerEvent {
        MainViewControllerEvent(
            name: Names.temperatureNotationSwitched,
            metadata: [
                "temperature_notation": notation
            ]
        )
    }
}
