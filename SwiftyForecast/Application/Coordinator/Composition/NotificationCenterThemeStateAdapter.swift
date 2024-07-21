//
//  NotificationCenterThemeStateAdapter.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 7/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import ThemeFeatureUI
import ThemeFeatureDomain

struct NotificationCenterThemeStateAdapter: ThemeStateChangeNotifiable {
    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    func notify(themeState: ThemeState) {
        notificationCenter.post(
            name: .didChangeTheme,
            object: nil,
            userInfo: ["themeState": themeState.description.lowercased()]
        )
    }
}

extension Notification.Name {
    static let didChangeTheme = Notification.Name("didChangeTheme")
}
