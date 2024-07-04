//
//  NotificationCenterThemeChangeAdapter.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 7/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
//import ThemeFeatureDomain
import ThemeFeatureDomain

struct NotificationCenterThemeChangeAdapter: ThemeChangeNotifiable {
    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    func notify() {
        notificationCenter.post(name: .didChangeTheme, object: nil)
    }
}

extension Notification.Name {
    static let didChangeTheme = Notification.Name("didChangeTheme")
}
