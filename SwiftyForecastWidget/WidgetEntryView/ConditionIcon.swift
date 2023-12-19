//
//  ConditionIcon.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct ConditionIcon: View {
    let icon: Image

    var body: some View {
        icon
            .resizable()
            .scaledToFit()
            .shadow(
                color: .white,
                radius: 0.5,
                x: 1,
                y: 1
            )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ConditionIcon(icon: Image(.cloudyDay))
        .padding()
}
