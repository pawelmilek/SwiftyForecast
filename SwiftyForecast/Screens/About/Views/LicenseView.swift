//
//  LicenseView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI

struct LicenseView: View {
    @StateObject private var reader = LicenseReader(fileName: "packages_license")

    var body: some View {
        HTMLView(fileURL: reader.fileURL)
            .padding(.top, 1)
            .navigationBarTitle("Licenses")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                try? reader.readFileURL()
            }
    }
}

#Preview {
    NavigationStack {
        LicenseView()
    }
}
