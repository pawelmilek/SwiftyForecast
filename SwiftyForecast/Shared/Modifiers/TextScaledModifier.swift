//
//  TextScaledModifier.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 12/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct TextScaledModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFit()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
    }
}

extension View {
    func textScaled() -> some View {
        modifier(TextScaledModifier())
    }
}
