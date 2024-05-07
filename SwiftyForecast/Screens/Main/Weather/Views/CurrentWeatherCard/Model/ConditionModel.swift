//
//  ConditionModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 5/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation

struct ConditionModel: Identifiable {
    let id: Int
    let iconCode: String
    let name: String
    let description: String
    let state: DayNightState

    init(id: Int, iconCode: String, name: String, description: String) {
        self.id = id
        self.iconCode = iconCode
        self.name = name
        self.description = description
        self.state = DayNightState(rawValue: String(iconCode.suffix(1)))!
    }
}
// swiftlint:enable identifier_name
