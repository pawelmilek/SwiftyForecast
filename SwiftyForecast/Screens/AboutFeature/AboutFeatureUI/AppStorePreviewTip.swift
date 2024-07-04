//
//  AppStorePreviewTip.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 3/11/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import TipKit

struct AppStorePreviewTip: Tip {
    public var options: [TipOption] {
        Tip.MaxDisplayCount(1)
    }

    var title: Text {
        Text("Preview")
            .fontWeight(.bold)
            .fontDesign(.monospaced)
    }

    var message: Text? {
        Text("Find more apps on the Apple Store.")
            .fontDesign(.monospaced)
    }

    var image: Image? {
        Image(systemName: "apple.logo")
    }
}
