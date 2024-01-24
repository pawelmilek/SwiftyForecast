//
//  BackgroundGroupBoxStyle.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 12/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct BackgroundGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .padding(.top, 40)
            .padding(.horizontal, 10)
            .background(.background)
            .cornerRadius(20)
            .overlay(
                configuration.label.padding(10),
                alignment: .topLeading
            )
    }
}
