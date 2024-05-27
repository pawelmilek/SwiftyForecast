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
    case appWebPage
    case appStoreReview
    case appStorePreview
    case weatherService

    var stringURL: String {
        switch self {
        case .privacyPolicy:
            "https://sites.google.com/view/pmilek/privacy-policy"
        case .appWebPage:
            "https://sites.google.com/view/pmilek/swifty-forecast"
        case .appStoreReview:
            "https://apps.apple.com/app/id1161186194?action=write-review"
        case .appStorePreview:
            "https://apps.apple.com/us/developer/pawel-milek/id1139599148"
        case .weatherService:
            "https://openweathermap.org"
        }
    }
}
