//
//  ThemeViewModel.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/28/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

final class ThemeViewModel: ObservableObject {
    @Published private(set) var themes = Theme.allCases
    @Published private(set) var title = "Appearance"
    @Published private(set) var subtitle = "Choose a day or night.\nCustomize your interface."
    @Published private(set) var pickerTitle = "Theme Settings"
    @Published private(set) var circleOffset = CGSize.zero
    let height = CGFloat(410)

    private let notification: ThemeChangeNotifiable
    private let analytics: AnalyticsThemeSendable

    init(notification: ThemeChangeNotifiable, analytics: AnalyticsThemeSendable) {
        self.notification = notification
        self.analytics = analytics
    }

    func postThemeChanged() {
        notification.notify()
    }

    func setLightCircleOffset() {
        circleOffset = CGSize(
            width: 150,
            height: -150
        )
    }

    func setDarkCircleOffset() {
        circleOffset = CGSize(
            width: 30,
            height: -25
        )
    }

    func sendScreenViewed() {
        analytics.send(
            name: ThemeAnalyticsEvent.screenViewed.name,
            metadata: ThemeAnalyticsEvent.screenViewed.metadata
        )
    }

    func sendColorSchemeSwitched(_ name: String) {
        let event = ThemeAnalyticsEvent.colorSchemeSwitched(scheme: name)
        analytics.send(
            name: event.name,
            metadata: event.metadata
        )
    }
}
