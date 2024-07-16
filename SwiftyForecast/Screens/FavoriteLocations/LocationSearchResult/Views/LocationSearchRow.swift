//
//  LocationSearchRow.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationSearchRow: View {
    private struct Style {
        static let fontDesign = Font.Design.monospaced
        static let titleFont = Font.callout
        static let subtitleFont = Font.subheadline
        static let titleFontWeight = Font.Weight.regular
        static let subtitleFontWeight = Font.Weight.bold
    }

    let result: MKLocalSearchCompletion
    var onAction: (MKLocalSearchCompletion) -> Void

    var body: some View {
        Button(action: {
            onAction(result)
        }, label: {
            VStack(alignment: .leading) {
                Text(result.title)
                    .font(Style.subtitleFont)
                    .fontWeight(Style.titleFontWeight)
                Text(result.subtitle)
                    .font(Style.subtitleFont)
                    .fontWeight(Style.subtitleFontWeight)
            }
            .fontDesign(Style.fontDesign)
            .frame(maxWidth: .infinity, alignment: .leading)
        })
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    LocationSearchRow(
        result: MKLocalSearchCompletion(),
        onAction: { _ in }
    )
    .padding()
}
