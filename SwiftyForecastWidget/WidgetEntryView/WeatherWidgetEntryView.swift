//
//  WeatherWidgetEntryView.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 12/8/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct WeatherWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: WeatherTimelineProvider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)

        case .systemMedium:
            MediumWidgetView(entry: entry)

        case .accessoryInline:
            InlineWidgetView(
                temperature: entry.formattedTemperature,
                location: entry.locationName
            )

        case .accessoryCircular:
            CircularWidgetView(
                current: entry.currentTemperature,
                min: entry.minTemperature,
                max: entry.maxTemperature
            )

        case .accessoryRectangular:
            RectangularWidgetView(
                currentFormatted: entry.formattedTemperature,
                maxMinFormatted: entry.formattedTemperatureMaxMin,
                conditionDescription: entry.description,
                dayNightState: entry.dayNightState
            )

        default:
            ContentUnavailableView(
                "Not Implemented \(family.debugDescription)",
                systemImage: "exclamationmark.triangle"
            )
            .foregroundStyle(.accent)
        }
    }
}
