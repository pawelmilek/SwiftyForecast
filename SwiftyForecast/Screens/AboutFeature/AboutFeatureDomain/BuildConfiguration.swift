//
//  BuildConfiguration.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 7/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

protocol BuildConfiguration {
    func weatherServiceAPIKey() -> String
    func supportEmailAddress() -> String
    func appStoreId() -> Int
}