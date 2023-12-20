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
    var entry: WeatherProvider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)

        case .systemMedium:
            MediumWidgetView(entry: entry)

        case .accessoryInline:
            InlineWidgetView(
                temperature: entry.temperatureFormatted,
                location: entry.locationName
            )

        case .accessoryCircular:
            CircularWidgetView(
                current: entry.temperatureCurrentValue,
                min: entry.temperatureMinValue,
                max: entry.temperatureMaxValue
            )

        case .accessoryRectangular:
            RectangularWidgetView(
                currentFormatted: entry.temperatureFormatted,
                maxMinFormatted: entry.temperatureMaxMinFormatted,
                conditionDescription: entry.description
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
