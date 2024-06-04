//
//  AnalyticsService.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/3/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import FirebaseAnalytics

protocol AnalyticsServiceProtocol: AnyObject {
    func send(event: String, metadata: [String: String])
}

final class AnalyticsService: AnalyticsServiceProtocol {
    func send(event: String, metadata: [String: String]) {
        Analytics.logEvent(event, parameters: metadata)
    }
}
