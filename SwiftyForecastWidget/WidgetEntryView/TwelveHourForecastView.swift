//
//  TwelveHourForecastView.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import WidgetKit

struct TwelveHourForecastView: View {
    let hourly: [HourlyEntry]

    var body: some View {
        HStack {
            ForEach(hourly, id: \.time) { item in
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

struct TwelveHourForecastView_Previews: PreviewProvider {
    static var previews: some View {
        TwelveHourForecastView(
            hourly: [
                HourlyEntry(
                    icon: Image(.rainyDay),
                    temperature: "69°",
                    time: "7:00 PM"
                ),
                HourlyEntry(
                    icon: Image(.cloudyNight),
                    temperature: "65°",
                    time: "10:00 PM"
                ),
                HourlyEntry(
                    icon: Image(.thunderDay),
                    temperature: "62°",
                    time: "1:00 AM"
                ),
                HourlyEntry(
                    icon: Image(.clearDay),
                    temperature: "55°",
                    time: "4:00 AM"
                )
            ]
        )
        .containerBackground(.widgetBackground, for: .widget)
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
