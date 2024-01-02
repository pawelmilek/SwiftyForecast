//
//  AppearanceTheme.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 1/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import UIKit
import SwiftUI

enum AppearanceTheme: String, CaseIterable {
    case systemDefault = "Default"
    case light = "Light"
    case dark = "Dark"

    func color(_ scheme: ColorScheme) -> Color {
        switch self {
        case .systemDefault:
            return scheme == .dark ? .shadow : .orange

        case .light:
            return .orange

        case .dark:
            return .shadow
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .systemDefault:
            return .none
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
