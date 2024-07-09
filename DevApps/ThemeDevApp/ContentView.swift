//
//  ContentView.swift
//  ThemeDevApp
//
//  Created by Pawel Milek on 7/3/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import SwiftUI
import ThemeFeatureUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: ThemeViewModel

    var body: some View {
        ThemeView(
            viewModel: viewModel,
            textColor: .accentColor,
            scheme: (dark: .red, light: .yellow)
        )
    }
}

#Preview {
    ContentView()
        .environmentObject(Preview.viewModel)
}
