//
//  AboutShareRow.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/3/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import SwiftUI

struct AboutShareRow: View {
    let item: URL
    let tintColor: Color

    var body: some View {
        Button { } label: {
            ShareLink(item: item) {
                labelView
            }
        }
    }

    private var labelView: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 30, height: 30)
                .foregroundStyle(tintColor)
                .overlay {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }
            Text("Share")
                .foregroundStyle(Color(UIColor.label))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.footnote)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    AboutShareRow(item: URL(string: "https://apps.apple.com/us/app/swifty-forecast/id1161186194")!,
        tintColor: .accent
    )
    .padding()
}
