//
//  TemperatureView.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct TemperatureView: View {
    let current: String
    let maxMin: String

    var body: some View {
        VStack(spacing: -10) {
            Text(current)
                .font(.system(size: 50, weight: .heavy, design: .monospaced))
                .textScaled()
            Text(maxMin)
                .font(.caption2)
                .fontWeight(.heavy)
        }
        .lineLimit(1)
        .foregroundStyle(.accent)
        .fontDesign(.monospaced)
    }
}

#Preview {
    TemperatureView(current: "87°", maxMin: "⏶ 92°  ⏷ 45°")
}
