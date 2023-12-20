//
//  CircularWidgetView.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/20/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import WidgetKit

struct CircularWidgetView: View {
    let current: Int
    let min: Int
    let max: Int

    private var currentValue: Double { Double(current) }
    private var minimumValue: Double { Double(min) }
    private var maximumValue: Double { Double(max) }

    var body: some View {
        Gauge(value: currentValue, in: minimumValue...maximumValue) {
            Text("Circular current temperature widget")
        } currentValueLabel: {
            Text("\(current)")
                .fontWeight(.heavy)
        } minimumValueLabel: {
            Text("\(min)")
                .fontWeight(.semibold)
        } maximumValueLabel: {
            Text("\(max)")
                .fontWeight(.semibold)
        }
        .gaugeStyle(.accessoryCircular)
    }
}
