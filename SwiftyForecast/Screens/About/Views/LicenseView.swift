//
//  LicenseView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct LicenseView: View {
    @StateObject private var license = PackageLicense()

    var body: some View {
        HTMLView(fileURL: license.url)
            .padding(.top, 1)
            .navigationBarTitle("Licenses")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                try? license.loadURL()
            }
    }
}

#Preview {
    NavigationStack {
        LicenseView()
    }
}
