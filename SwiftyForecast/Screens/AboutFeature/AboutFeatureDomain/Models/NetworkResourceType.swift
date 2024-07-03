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
    case appShare(appId: Int)
    case appStoreReview(appId: Int)
    case appStorePreview
    case weatherService

    var stringURL: String {
        switch self {
        case .privacyPolicy:
            "https://sites.google.com/view/pmilek/privacy-policy"
        case .appShare(let appId):
            "https://apps.apple.com/app/id\(appId)"
        case .appStoreReview(let appId):
            "https://apps.apple.com/app/id\(appId)?action=write-review"
        case .appStorePreview:
            "https://apps.apple.com/us/developer/pawel-milek/id1139599148"
        case .weatherService:
            "https://openweathermap.org"
        }
    }
}
