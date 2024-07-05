//
//  ThemeTip.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 7/5/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import TipKit

public struct ThemeTip: Tip {
    public static let didTipBecomePresentableEvent = Event(id: "didTipBecomePresentableEvent")

    public init() {
    }

    public var title: Text {
        Text("Theme")
            .fontWeight(.bold)
            .fontDesign(.monospaced)
    }

    public var message: Text? {
        Text("Choose a style of the app you like the most.")
            .fontDesign(.monospaced)
    }

    public var image: Image? {
        Image(systemName: "circle.lefthalf.filled.inverse")
    }

    public var rules: [Rule] {
        [
            #Rule(Self.didTipBecomePresentableEvent) { $0.donations.count == 1 }
        ]
    }
}

