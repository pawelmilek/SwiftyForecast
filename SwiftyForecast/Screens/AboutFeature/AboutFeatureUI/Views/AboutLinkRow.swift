//
//  AboutLinkRow.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/3/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import SwiftUI

struct AboutLinkRow: View {
    let tintColor: Color
    let symbol: String
    let title: String
    let url: URL?

    var body: some View {
        Button(action: {}, label: {
            Link(destination: url!, label: {
                labelView
            })
        })
    }

    private var labelView: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 30, height: 30)
                    .foregroundStyle(tintColor)
                Image(systemName: symbol)
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)

            }
            Text(title)
                .font(.footnote)
                .foregroundStyle(Color(.label))
                .fontDesign(.monospaced)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    AboutLinkRow(
        tintColor: .pink,
        symbol: "globe",
        title: "Website",
        url: URL(string: "https://sites.google.com/view/pmilek/home")!
    )
    .padding()
}
