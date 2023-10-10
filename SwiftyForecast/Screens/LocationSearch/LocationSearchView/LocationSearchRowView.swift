//
//  LocationSearchRowView.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct LocationSearchRowView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.regular)
            Text(subtitle)
                .font(.caption)
                .fontWeight(.bold)
        }
        .fontDesign(.rounded)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    LocationSearchRowView(title: "Chicago", subtitle: "Uniated States")
        .padding()
}
