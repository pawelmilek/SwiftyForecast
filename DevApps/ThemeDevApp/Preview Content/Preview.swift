//
//  Preview.swift
//  ThemeDevApp
//
//  Created by Pawel Milek on 7/5/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import ThemeFeatureUI
import ThemeFeatureDomain
import ThemeFeatureData

@MainActor
enum Preview {
    static var viewModel: ThemeViewModel {
        ThemeViewModel(
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
    }
}
