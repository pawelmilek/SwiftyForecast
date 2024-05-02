//
//  ConditionDescriptionView.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct ConditionDescriptionView: View {
    let description: String

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(description)
                .font(.caption2)
                .fontWeight(.semibold)
                .fontDesign(.monospaced)
                .foregroundStyle(.accent)
                .lineLimit(2)
                .padding(.vertical, 3)
                .padding(.horizontal, 10)
        }
        .background(
            Color.white
                .opacity(0.4)
                .clipShape(RoundedRectangle(cornerRadius: 9))
        )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ConditionDescriptionView(description: "scattered clouds")
        .padding()
}
