//
//  AboutFrameworkView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/30/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct AboutFrameworkView: View {
    let title: String
    let content: [String]

    var body: some View {
        DisclosureGroup {
            ForEach(content, id: \.self) { item in
                HStack {
                    Text(item)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.accent)
                    Spacer()
                    Image(systemName: "books.vertical.fill")
                        .foregroundStyle(.orange)

                }
                .font(.caption)
                .fontWeight(.heavy)
                .padding(.leading, 15)
            }
        } label: {
            AboutRow(
                tintColor: .orange,
                symbol: "swift",
                title: title,
                content: nil,
                link: nil,
                action: nil
            )
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    AboutFrameworkView(
        title: "Frameworks",
        content: [
            "UIKit",
            "SwiftUI",
            "Combine",
            "Charts",
            "WidgetKit",
            "MapKit",
            "StoreKit",
            "WebKit",
            "TipKit"
        ]
    )
        .padding()
}
