//
//  MediumWidgetView.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/20/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct MediumWidgetView: View {
    var entry: WeatherTimelineProvider.Entry

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
            LocationView(name: entry.name)
            Text(entry.formattedTemperature)
                .font(.system(size: 60, weight: .heavy, design: .monospaced))
                .foregroundStyle(.accent)
                .textScaled()
        }
    }

    var temperatureMaxMinAndCondition: some View {
        VStack(alignment: .trailing, spacing: 5) {
            HStack(alignment: .bottom, spacing: 0) {
                Text(entry.formattedTemperatureMaxMin)
                    .font(.caption2)
                    .fontWeight(.heavy)
                    .foregroundStyle(.accent)
                ConditionView(icon: Image(uiImage: .init(data: entry.icon) ?? UIImage(resource: .clearDay)))
                    .frame(maxWidth: 40)
            }
            ConditionDescriptionView(description: entry.description)
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
                        Text(item.formattedTemperature)
                            .font(.footnote)
                            .fontWeight(.heavy)
                            .fontDesign(.monospaced)
                            .foregroundStyle(.accent)
                        ConditionView(icon: Image(uiImage: .init(data: entry.icon) ?? UIImage(resource: .clearDay)))
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
