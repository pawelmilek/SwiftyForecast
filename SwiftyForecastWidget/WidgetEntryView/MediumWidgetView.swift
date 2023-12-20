//
//  MediumWidgetView.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/20/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct MediumWidgetView: View {
    var entry: WeatherProvider.Entry

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    locationAndTemperature
                        .frame(maxWidth: proxy.size.width * 0.4, alignment: .leading)
                    temperatureMaxMinAndCondition
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(maxHeight: proxy.size.height * 0.6, alignment: .top)
                twelveHourForecastView
            }
        }
    }
}

private extension MediumWidgetView {
    var locationAndTemperature: some View {
        VStack(spacing: 0) {
            LocationView(name: entry.locationName)
            Text(entry.temperatureFormatted)
                .font(.system(size: 60, weight: .heavy, design: .monospaced))
                .foregroundStyle(.accent)
                .modifier(TextScaledModifier())
        }
    }

    var temperatureMaxMinAndCondition: some View {
        VStack(alignment: .trailing, spacing: 5) {
            HStack(alignment: .bottom, spacing: 0) {
                Text(entry.temperatureMaxMinFormatted)
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

    var twelveHourForecastView: some View {
        HStack {
            ForEach(entry.hourly, id: \.time) { item in
                VStack(spacing: 5) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Spacer()
                        Text(item.temperature)
                            .font(.footnote)
                            .fontWeight(.heavy)
                            .fontDesign(.monospaced)
                            .foregroundStyle(.accent)
                        ConditionIcon(icon: item.icon)
                            .frame(maxWidth: 40)
                    }
                    Text(item.time)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.accent)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
