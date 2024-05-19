//
//  CopyrightFooterView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 5/18/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import SwiftUI

struct CopyrightFooterView: View {
    private var currentYear: String {
        Date.now.formatted(.dateTime.year())
    }

    var body: some View {
        Text("Copyright © \(currentYear) All rights reserved.")
            .font(.caption)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .foregroundStyle(.accent.opacity(0.8))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 4)
    }
}

#Preview {
    CopyrightFooterView()
}
