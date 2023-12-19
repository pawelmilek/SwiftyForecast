//
//  LocationView.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/18/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct LocationView: View {
    let name: String

    var body: some View {
        HStack(spacing: 3) {
            Text(name)
                .font(.caption)
                .fontWeight(.semibold)
                .fontDesign(.monospaced)
                .foregroundStyle(.white)
            Image(systemName: "location.fill")
                .font(.system(size: 10))
                .foregroundStyle(.white)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    LocationView(name: "Chicago")
        .padding()
}
