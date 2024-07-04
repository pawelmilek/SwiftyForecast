//
//  ThemeDevAppApp.swift
//  ThemeDevApp
//
//  Created by Pawel Milek on 7/3/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import SwiftUI
import ThemeFeatureUI

@main
struct ThemeDevAppApp: App {
    @StateObject private var viewModel = ThemeViewModel(
        notification: NotificationCenterThemeChangeAdapter(
            notificationCenter: .default
        ),
        analytics: PreviewAnalyticsTheme()
    )

    var body: some Scene {
        WindowGroup {
            ContentView(
                textColor: .accentColor,
                darkScheme: .purple,
                lightScheme: .primary
            )
            .environmentObject(viewModel)
        }
    }
}
