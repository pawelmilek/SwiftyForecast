//
//  Preview.swift
//  ThemeDevApp
//
//  Created by Pawel Milek on 7/5/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import ThemeFeatureUI
import ThemeFeatureData

enum Preview {
    static var viewModel: ThemeViewModel {
        ThemeViewModel(
            repository: UserDefaultsThemeRepository(storage: .init(suiteName: "preivew")!),
            notification: NotificationCenterThemeAdapter(
                notificationCenter: .default
            ),
            analytics: FirebaseAnalyticsThemeAdapter(
                service: FakeAnalyticsService()
            )
        )
    }
}
