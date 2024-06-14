//
//  ActionAboutRow.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/3/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import SwiftUI

struct ActionAboutRow: View {
    let tintColor: Color
    let symbol: String
    let title: String
    let action: (() -> Void)

    var body: some View {
        Button(action: action) {
            labelView
        }
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
                .fontDesign(.monospaced)
                .foregroundStyle(Color(.label))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ActionAboutRow(
        tintColor: .blue,
        symbol: "apps.iphone",
        title: "Application",
        action: { }
    )
    .padding()
}
