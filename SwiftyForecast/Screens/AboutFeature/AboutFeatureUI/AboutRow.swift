//
//  AboutRow.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/23/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct AboutRow: View {
    let tintColor: Color
    let symbol: String
    let title: String
    let content: String

    var body: some View {
        HStack {
            labelView
            contentView
        }
    }

    private var contentView: some View {
        Text(content)
            .font(.footnote)
            .fontWeight(.heavy)
            .fontDesign(.monospaced)
            .foregroundStyle(.accent)
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

#Preview(traits: .sizeThatFitsLayout) {
    AboutRow(
        tintColor: .blue,
        symbol: "apps.iphone",
        title: "Application",
        content: "Swifty Forecast"
    )
    .padding()
}
