//
//  FirebaseAnalyticsThemeAdapter.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 7/2/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import ThemeFeatureDomain

struct FirebaseAnalyticsThemeAdapter: ThemeAnalyticsSendable {
    private struct Event: AnalyticsEvent {
        var name: String
        var metadata: [String: Any]
    }

    private let service: AnalyticsService

    init(service: AnalyticsService) {
        self.service = service
    }

    func send(name: String, metadata: [String: Any]) {
        service.send(event: Event(name: name, metadata: metadata))
    }
}
