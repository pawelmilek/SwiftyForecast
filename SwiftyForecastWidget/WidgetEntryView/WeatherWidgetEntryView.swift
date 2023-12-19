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
            systemSmallView

        case .systemMedium:
            systemMediumView

        default:
            systemSmallView
        }
    }
}

private extension WeatherWidgetEntryView {

    var systemSmallView: some View {
        GeometryReader { proxy in
            ConditionIcon(icon: entry.icon)
                .frame(maxWidth: proxy.size.width * 0.5)

            TemperatureView(
                current: entry.temperature,
                maxMin: entry.temperatureMaxMin
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

    var systemMediumView: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    locationAndTemperature
                        .frame(maxWidth: proxy.size.width * 0.4, alignment: .leading)
                    temperatureMaxMinAndCondition
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(maxHeight: proxy.size.height * 0.6, alignment: .top)
                TwelveHourForecastView(hourly: entry.hourly)
            }
        }
    }

    var locationAndTemperature: some View {
        VStack(spacing: 0) {
            LocationView(name: entry.locationName)
            Text(entry.temperature)
                .font(.system(size: 60, weight: .heavy, design: .monospaced))
                .foregroundStyle(.accent)
                .modifier(TextScaledModifier())
        }
    }

    var temperatureMaxMinAndCondition: some View {
        VStack(alignment: .trailing, spacing: 5) {
            HStack(alignment: .bottom, spacing: 0) {
                Text(entry.temperatureMaxMin)
                    .font(.caption2)
                    .fontWeight(.heavy)
                    .foregroundStyle(.accent)
                ConditionIcon(icon: entry.icon)
                    .frame(maxWidth: 40)
            }
            ConditionDescription(description: entry.description)
                .scaledToFit()
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
    }
}
