//
//  ReviewedVersionStorage.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/24/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

protocol ReviewedVersionStorage {
    func version() -> String?
    func save(_ version: String)
}
