//
//  ReviewDesirableMomentType.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

enum ReviewDesirableMomentType: Int {
    case locationAdded
    case enjoyableTemperatureReached

    var key: Int {
        self.rawValue
    }
}
