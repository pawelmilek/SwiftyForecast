//
//  ThemeViewViewModel.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/28/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class ThemeViewViewModel: ObservableObject {
    @AppStorage("appearanceTheme") var appearanceTheme: AppearanceTheme = .systemDefault
    @Published var selectedTheme: AppearanceTheme = .systemDefault
    @Published private(set) var themes = AppearanceTheme.allCases
    @Published private(set) var title = "Appearance"
    @Published private(set) var subtitle = "Choose a day or night.\nCustomize your interface."
    @Published private(set) var pickerTitle = "Theme Settings"
    @Published private(set) var circleOffset = CGSize.zero
    @Published private(set) var height = CGFloat(410)

    private var cancellables = Set<AnyCancellable>()
    private let analyticsService: AnalyticsService
    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter, analyticsService: AnalyticsService) {
        self.notificationCenter = notificationCenter
        self.analyticsService = analyticsService
        self.selectedTheme = appearanceTheme
        subscribePublisher()
    }

    private func subscribePublisher() {
        $selectedTheme
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedTheme in
                guard let self else { return }
                appearanceTheme = selectedTheme
                setCircleOffset(isDark: selectedTheme == .dark)
                appearanceChanged()
            }
            .store(in: &cancellables)
    }

    private func appearanceChanged() {
        notificationCenter.post(name: .didChangeAppearance, object: nil)
    }

    func setCircleOffset(isDark: Bool) {
        circleOffset = CGSize(
            width: isDark ? 30 : 150,
            height: isDark ? -25 : -150
        )
    }

    func gradientColor(for colorScheme: ColorScheme) -> AnyGradient {
        selectedTheme.color(colorScheme).gradient
    }

    func logScreenViewed() {
        analyticsService.send(
            event: ScreenAnalyticsEvent.screenViewed(
                name: "Appearance Screen",
                className: "\(type(of: self))"
            )
        )
    }

    func logColorShemeSwitched(_ colorScheme: ColorScheme) {
        analyticsService.send(
            event: ThemeViewEvent.colorSchemeSwitched(
                name: String(describing: colorScheme)
            )
        )
    }
}
