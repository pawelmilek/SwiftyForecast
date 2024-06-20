//
//  SmallWidgetView.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/20/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct SmallWidgetView: View {
    let entry: WeatherTimelineProvider.Entry

    var body: some View {
        GeometryReader { proxy in
            ConditionView(icon: Image(uiImage: .init(data: entry.icon) ?? UIImage(resource: .clearDay)))
                .frame(maxWidth: proxy.size.width * 0.5)

            TemperatureView(
                current: entry.formattedTemperature,
                maxMin: entry.formattedTemperatureMaxMin
            )
            .frame(maxWidth: proxy.size.width)
            .offset(y: 30)
        }
        .overlay(alignment: .bottom) {
            ConditionDescriptionView(description: entry.description)
                .frame(maxWidth: .infinity)
        }
        .overlay(alignment: .topTrailing) {
            LocationView(name: entry.locationName)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
