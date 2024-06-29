//
//  Theme.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 1/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//
// swiftlint:disable:identifier_name

import UIKit
import SwiftUI

enum Theme: String, CaseIterable, Identifiable {
    case systemDefault = "Default"
    case light = "Light"
    case dark = "Dark"

    var id: Self { self }

    func color(_ scheme: ColorScheme) -> Color {
        switch self {
        case .systemDefault:
            return scheme == .dark ? .purple : .customPrimary

        case .light:
            return .customPrimary

        case .dark:
            return .purple
        }
    }
}
