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
    let label: String?
    let link: (destination: String, label: String)?
    let action: (() -> Void)?

    var body: some View {
        LabeledContent {
            contentView
        } label: {
            labelView
        }
    }

    @ViewBuilder
    private var contentView: some View {
        Group {
            if let label {
                Text(label)
                    .foregroundStyle(.accent)
                    .fontWeight(.heavy)
            } else if let link, let destination = URL(string: link.destination) {
                Link(destination: destination) {
                    Text(link.label)
                        .fontWeight(.heavy)
                        .foregroundStyle(tintColor)
                }
            } else if let action {
                Button("", action: action)
            } else {
                EmptyView()
            }
        }
        .font(.footnote)
        .fontDesign(.monospaced)
    }

    private var labelView: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 30, height: 30)
                .foregroundStyle(tintColor)
                .overlay {
                    Image(systemName: symbol)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }
            Text(title)
                .font(.footnote)
                .fontDesign(.monospaced)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    AboutRow(
        tintColor: .blue,
        symbol: "apps.iphone",
        title: "Application",
        label: "Swifty Forecast",
        link: nil,
        action: nil
    )
    .padding()
}

#Preview(traits: .sizeThatFitsLayout) {
    AboutRow(
        tintColor: .pink,
        symbol: "globe",
        title: "Website",
        label: nil,
        link: (
            destination: "https://sites.google.com/view/pmilek/home",
            label: "Swifty Forecast"
        ),
        action: nil
    )
    .padding()
}
