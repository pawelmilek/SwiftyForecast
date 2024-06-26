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

    private let analyticsService: AnalyticsService
    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter, analyticsService: AnalyticsService) {
        self.notificationCenter = notificationCenter
        self.analyticsService = analyticsService
    }

    func postThemeChanged() {
        notificationCenter.post(name: .didChangeTheme, object: nil)
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
        analyticsService.send(
            event: ScreenAnalyticsEvent.screenViewed(
                name: "Appearance Screen",
                className: "\(type(of: self))"
            )
        )
    }

    func sendColorSchemeSwitched(_ colorSchemeName: String) {
        analyticsService.send(
            event: ThemeViewEvent.colorSchemeSwitched(
                name: colorSchemeName
            )
        )
    }
}
