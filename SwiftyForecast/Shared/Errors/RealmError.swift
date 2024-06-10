//
//  RealmError.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

enum RealmError: ErrorPresentable {
    case initializationFailed
    case transactionFailed(description: String)
    case fetchFailed
    case unknown

    var errorDescription: String? {
        switch self {
        case .initializationFailed:
            return "Realm initialization failed."

        case .transactionFailed(let description):
            return "Realm transaction \(description) failed."

        case .fetchFailed:
            return "Could not fetch from Realm."

        case .unknown:
            return "Realm unknown error."
        }
    }
}
