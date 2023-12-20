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

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
                .cornerRadius(8)
            VStack {
                HStack {
                    Text(currentFormatted)
                        .fontWeight(.heavy)
                    Spacer()
                    Text(maxMinFormatted)
                        .fontWeight(.semibold)
                }
                .lineLimit(1)
                Text(conditionDescription)
                    .font(.footnote)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
