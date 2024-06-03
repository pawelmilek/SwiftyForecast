//
//  AnalyticsService.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/3/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import FirebaseAnalytics

final class AnalyticsService: LogEventService {
    func log(event: String, parameters: [String: Any]) {
        Analytics.logEvent(event, parameters: parameters)
    }
}
