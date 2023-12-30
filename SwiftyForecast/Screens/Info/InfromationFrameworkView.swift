//
//  InfromationFrameworkView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/30/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct InfromationFrameworkView: View {
    private let frameworks = [
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
    var body: some View {
        DisclosureGroup {
            ForEach(frameworks, id: \.self) { item in
                HStack {
                    Text(item)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: "books.vertical.fill")
                        .foregroundStyle(.orange)

                }
                .font(.caption)
                .fontWeight(.heavy)
                .padding(.leading, 15)
            }
        } label: {
            InfoRow(
                tintColor: .orange,
                symbol: "swift",
                title: "Frameworks",
                content: nil,
                link: nil,
                action: nil
            )
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    InfromationFrameworkView()
        .padding()
}
