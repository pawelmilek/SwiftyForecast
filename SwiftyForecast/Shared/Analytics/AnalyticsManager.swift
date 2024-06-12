//
//  AnalyticsManager.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/3/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

final class AnalyticsManager: ObservableObject {
    private let service: AnalyticsService

    init(service: AnalyticsService) {
        self.service = service
    }

    func send(event: AnalyticsEvent) {
        service.send(event: event)
    }
}
