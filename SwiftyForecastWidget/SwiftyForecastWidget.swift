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
    private enum Constant {
        static let kind = "com.pawelmilek.Swifty-Forecast.widget"
        static let supportedFamilies: [WidgetFamily] = [.systemSmall, .systemMedium]
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: Constant.kind,
            provider: WeatherProvider()
        ) { entry in
            WeatherWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .containerBackground(.widgetBackground, for: .widget)
        }
        .configurationDisplayName("Weather")
        .description("Glance the current conditions and forecast for a location.")
        .supportedFamilies(Constant.supportedFamilies)
    }
}

#Preview(as: .systemSmall) {
    SwiftyForecastWidget()
} timeline: {
    WeatherEntry.sampleTimeline.first!
    WeatherEntry.sampleTimeline.last!
}

#Preview(as: .systemMedium) {
    SwiftyForecastWidget()
} timeline: {
    WeatherEntry.sampleTimeline.first!
    WeatherEntry.sampleTimeline.last!
}
