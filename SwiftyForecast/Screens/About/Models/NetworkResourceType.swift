//
//  NetworkResourceType.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 5/27/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

enum NetworkResourceType {
    case privacyPolicy
    case appStoreReview
    case weatherService

    var stringURL: String {
        switch self {
        case .privacyPolicy:
            "https://sites.google.com/view/pmilek/privacy-policy"
        case .appStoreReview:
            "https://apps.apple.com/app/id1161186194?action=write-review"
        case .weatherService:
            "https://openweathermap.org"
        }
    }
}
