//
//  ConditionIcon.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 5/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation

struct ConditionIcon: Identifiable {
    let id: Int
    let code: String
    let dayNightState: DayNightState

    init(id: Int, code: String) {
        self.id = id
        self.code = code
        self.dayNightState = DayNightState(rawValue: String(code.suffix(1)))!
    }
}

// swiftlint:enable identifier_name
