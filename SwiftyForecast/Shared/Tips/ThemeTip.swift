//
//  ThemeTip.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 1/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import TipKit

struct ThemeTip: Tip {
    static let didAppBecomeActiveEvent = Event(id: "didAppBecomeActiveEvent")

    var title: Text {
        Text("Theme")
            .fontWeight(.bold)
            .fontDesign(.monospaced)
    }

    var message: Text? {
        Text("Choose a style of the app you like the most.")
            .fontDesign(.monospaced)
    }

    var image: Image? {
        Image(systemName: "circle.lefthalf.filled.inverse")
    }

    var rules: [Rule] {
        [
            #Rule(Self.didAppBecomeActiveEvent) { $0.donations.count == 1 }
        ]
    }
}
