//
//  ThemeDevAppApp.swift
//  ThemeDevApp
//
//  Created by Pawel Milek on 7/3/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import SwiftUI
import ThemeFeatureUI
import ThemeFeatureDomain
import ThemeFeatureData

@main
struct ThemeDevAppApp: App {
    @StateObject private var viewModel = ThemeViewModel(
        repository: ThemeRepository(
            dataSource: UserDefaultsThemeDataSource(
                storage: .standard,
                decoder: JSONDecoder(),
                encoder: JSONEncoder()
            )
        ),
        notification: NotificationCenterThemeStateAdapter(
            notificationCenter: .default
        ),
        analytics: FirebaseAnalyticsThemeAdapter(
            service: FakeAnalyticsService()
        )
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
