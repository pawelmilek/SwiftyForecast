//
//  InlineWidgetView.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/20/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import WidgetKit

struct InlineWidgetView: View {
    let temperature: String
    let location: String

    var body: some View {
        ViewThatFits {
            Text("\(temperature) \(location)")
            Text("\(temperature)")
        }
    }
}
