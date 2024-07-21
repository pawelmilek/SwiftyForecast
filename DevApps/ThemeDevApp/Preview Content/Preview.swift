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
            service: ThemeService(
                repository: ThemeRepository(
                    dataSource: LocalThemeDataSource(
                        storage: .init(suiteName: "preivew")!
                    ),
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
