//
//  ContentView.swift
//  AboutDevApp
//
//  Created by Pawel Milek on 7/5/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import SwiftUI
import AboutFeatureUI

struct ContentView: View {
    @EnvironmentObject private var viewMdoel: AboutViewModel

    var body: some View {
        AboutView(
            viewModel: viewMdoel,
            tintColor: .customPrimary,
            accentColor: .accent
        )
    }
}

#Preview {
    ContentView()
        .environmentObject(Preview.viewModel)
}
