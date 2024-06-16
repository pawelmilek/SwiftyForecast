//
//  Condition.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/12/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct Condition: Codable {
    // swiftlint:disable:next identifier_name
    let id: Int
    let main: String
    let description: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        // swiftlint:disable:next identifier_name
        case id
        case main
        case description
        case icon
    }
}
