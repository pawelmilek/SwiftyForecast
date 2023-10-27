//
//  LocationSearchResultRow.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationSearchResultRow: View {
    let result: MKLocalSearchCompletion
    var onAction: (MKLocalSearchCompletion) -> Void

    var body: some View {
        Button(action: {
            onAction(result)
        }, label: {
            VStack(alignment: .leading) {
                Text(result.title)
                    .font(Style.LocationSearchResultRow.subtitleFont)
                    .fontWeight(Style.LocationSearchResultRow.titleFontWeight)
                Text(result.subtitle)
                    .font(Style.LocationSearchResultRow.subtitleFont)
                    .fontWeight(Style.LocationSearchResultRow.subtitleFontWeight)
            }
            .fontDesign(Style.LocationSearchResultRow.fontDesign)
            .frame(maxWidth: .infinity, alignment: .leading)
        })
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    LocationSearchResultRow(
        result: MKLocalSearchCompletion(),
        onAction: { _ in }
    )
    .padding()
}
