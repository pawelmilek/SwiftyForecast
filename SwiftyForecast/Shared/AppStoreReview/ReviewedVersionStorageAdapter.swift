//
//  ReviewedVersionStorageAdapter.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/24/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct ReviewedVersionStorageAdapter: ReviewedVersionStorage {
    private static let reviewedVersionKey = "ReviewedVersionKey"
    private let adaptee: UserDefaults

    init(adaptee: UserDefaults) {
        self.adaptee = adaptee
    }

    func version() -> String? {
        adaptee.string(forKey: Self.reviewedVersionKey)
    }
    
    func save(_ version: String) {
        adaptee.set(Self.reviewedVersionKey, forKey: version)
    }
}
