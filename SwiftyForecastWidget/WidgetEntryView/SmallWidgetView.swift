//
//  SmallWidgetView.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/20/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct SmallWidgetView: View {
    let entry: WeatherProvider.Entry

    var body: some View {
        GeometryReader { proxy in
            ConditionIcon(icon: entry.icon)
                .frame(maxWidth: proxy.size.width * 0.5)

            TemperatureView(
                current: entry.temperatureFormatted,
                maxMin: entry.temperatureMaxMinFormatted
            )
            .frame(maxWidth: proxy.size.width)
            .offset(y: 30)
        }
        .overlay(alignment: .bottom) {
            ConditionDescription(description: entry.description)
                .frame(maxWidth: .infinity)
        }
        .overlay(alignment: .topTrailing) {
            LocationView(name: entry.locationName)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
