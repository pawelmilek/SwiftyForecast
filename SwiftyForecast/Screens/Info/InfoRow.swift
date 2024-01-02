//
//  InfoRow.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/23/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct InfoRow: View {
    let tintColor: Color
    let symbol: String
    let title: String
    let content: String?
    let link: (destination: String, label: String)?
    let action: (() -> Void)?

    var body: some View {
        LabeledContent {
            if let content {
                Text(content)
                    .foregroundStyle(.customPrimary)
                    .fontWeight(.heavy)
            } else if let link {
                Link(destination: URL(string: link.destination)!,
                     label: {
                    Text(link.label)
                        .fontWeight(.heavy)
                        .foregroundStyle(tintColor)
                })
            } else if let action {
                Button("", action: action)
            } else {
                EmptyView()
            }
        } label: {
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
            }
        }
        .font(.footnote)
        .fontDesign(.monospaced)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    InfoRow(
        tintColor: .blue,
        symbol: "apps.iphone",
        title: "Application",
        content: "Swifty Forecast",
        link: nil,
        action: nil
    )
    .padding()
}

#Preview(traits: .sizeThatFitsLayout) {
    InfoRow(
        tintColor: .pink,
        symbol: "globe",
        title: "Website",
        content: nil,
        link: (
            destination: "https://sites.google.com/view/pmilek/home",
            label: "Swifty Forecast"
        ),
        action: nil
    )
    .padding()
}
