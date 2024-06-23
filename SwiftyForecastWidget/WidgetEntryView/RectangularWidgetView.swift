//
//  RectangularWidgetView.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/20/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RectangularWidgetView: View {
    let currentFormatted: String
    let maxMinFormatted: String
    let conditionDescription: String
    let dayNightState: DayNightState

    private var symbol: String {
        dayNightState == .day ? "sun.max.circle.fill" : "moon.stars.circle.fill"
    }

    var body: some View {
        VStack {
            HStack(spacing: 5) {
                Image(systemName: symbol)
                    .contentTransition(.symbolEffect(.replace.offUp))
                Text(dayNightState.description)
            }
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text(currentFormatted)
                    .fontWeight(.heavy)
                Spacer()
                Text(maxMinFormatted)
            }
            .lineLimit(1)
            Text(conditionDescription)
                .textScaled()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
