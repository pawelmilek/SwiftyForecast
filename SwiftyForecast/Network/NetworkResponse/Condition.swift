//
//  Condition.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/12/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct Condition: Codable {
    let identifier: Int
    let main: String
    let description: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case main
        case description
        case icon
    }
}
