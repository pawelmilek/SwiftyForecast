//
//  NotificationCenterThemeAdapter.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 7/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import ThemeFeatureUI

struct NotificationCenterThemeAdapter: ThemeChangeNotifiable {
    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    func notify(newTheme: String) {
        notificationCenter.post(
            name: .didChangeTheme,
            object: nil,
            userInfo: ["theme": newTheme]
        )
    }
}

extension Notification.Name {
    static let didChangeTheme = Notification.Name("didChangeTheme")
}
