//
//  SwiftyForecastWidgetEntryView.swift
//  SwiftyForecast Widget
//
//  Created by Pawel Milek on 12/6/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import WidgetKit
import SwiftUI

struct SwiftyForecastWidget: Widget {
    let kind = "com.pawelmilek.Swifty-Forecast.widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: WeatherProvider()
        ) { entry in
            CurrentWeatherView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .containerBackground(.widgetBackground, for: .widget)
        }
        .configurationDisplayName("Weather")
        .description("Glance the conditions for current location.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    SwiftyForecastWidget()
} timeline: {
    WeatherEntry.sampleTimeline.first!
    WeatherEntry.sampleTimeline.last!
}
