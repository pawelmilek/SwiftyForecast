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

enum Preview {
    static var viewModel: ThemeViewModel {
        ThemeViewModel(
            service: ThemeStorageService(
                repository: ThemeRepository(
                    dataSource: LocalThemeDataSource(
                        storage: .init(suiteName: "preivew")!
                    )
                ),
                encoder: JSONEncoder(),
                decoder: JSONDecoder()
            ),
            notification: NotificationCenterThemeAdapter(
                notificationCenter: .default
            ),
            analytics: FirebaseAnalyticsThemeAdapter(
                service: FakeAnalyticsService()
            )
        )
    }
}
