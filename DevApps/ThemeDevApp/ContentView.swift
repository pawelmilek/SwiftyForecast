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
    let textColor: Color
    let darkScheme: Color
    let lightScheme: Color

    var body: some View {
        ThemeView(
            viewModel: ThemeViewModel(
                notification: NotificationCenterThemeChangeAdapter(
                    notificationCenter: .default
                ),
                analytics: PreviewAnalyticsTheme()
            ),
            textColor: .accentColor,
            darkScheme: .red,
            lightScheme: .yellow
        )
    }
}

#Preview {
    ContentView(
        textColor: .accentColor,
        darkScheme: .purple,
        lightScheme: .primary
    )
    .environmentObject(
        ThemeViewModel(
            notification: NotificationCenterThemeChangeAdapter(
                notificationCenter: .default
            ),
            analytics: PreviewAnalyticsTheme()
        )
    )
}
