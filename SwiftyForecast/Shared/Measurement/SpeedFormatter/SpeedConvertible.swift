//
//  SpeedConvertible.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/23/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

protocol SpeedConvertible {
    func speed(_ value: Double) -> Measurement<UnitSpeed>
}
