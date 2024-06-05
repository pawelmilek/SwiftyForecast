//
//  FirebaseAnalyticsService.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/3/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import FirebaseAnalytics

final class FirebaseAnalyticsService: AnalyticsService {
    func send(event: String, metadata: [String: String]) {
        Analytics.logEvent(event, parameters: metadata)
    }
}
