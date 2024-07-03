//
//  Theme.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 1/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//
// swiftlint:disable:identifier_name

import UIKit

public enum Theme: String, CaseIterable, Identifiable {
    case systemDefault = "Default"
    case light = "Light"
    case dark = "Dark"

    public var id: Self { self }
}
