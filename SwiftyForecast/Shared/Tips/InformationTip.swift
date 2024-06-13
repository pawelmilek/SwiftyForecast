//
//  InformationTip.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/29/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import TipKit

struct InformationTip: Tip {
    var options: [Option] {
        MaxDisplayCount(1)
    }

    var title: Text {
        Text("Information")
            .fontWeight(.bold)
            .fontDesign(.monospaced)
    }

    var message: Text? {
        Text("Find important details about the app, feedback and more.")
            .fontDesign(.monospaced)
    }

    var image: Image? {
        Image(systemName: "info.circle.fill")
    }
}
