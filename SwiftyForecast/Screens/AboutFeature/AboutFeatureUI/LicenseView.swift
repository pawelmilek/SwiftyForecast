//
//  LicenseView.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 12/24/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//
// swiftlint:disable force_try

import SwiftUI

struct LicenseView: View {
    let content: URL

    var body: some View {
        HTMLView(fileURL: content)
            .padding(.top, 1)
            .navigationBarTitle("Licenses")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LicenseView(
            content: try! ResourceFile(
                name: "packages_license",
                fileExtension: "html",
                bundle: .main
            ).url()
        )
    }
}
