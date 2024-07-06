//
//  FirebaseAnalyticsAboutAdapter.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 7/3/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import AboutFeatureUI

struct FirebaseAnalyticsAboutAdapter: AnalyticsAboutSendable {
    private struct Event: AnalyticsEvent {
        var name: String
        var metadata: [String: Any]
    }

    private let service: AnalyticsService

    init(service: AnalyticsService) {
        self.service = service
    }

    func send(name: String, metadata: [String: Any]) {
        service.send(
            event: Event(
                name: name,
                metadata: metadata
            )
        )
    }
}
