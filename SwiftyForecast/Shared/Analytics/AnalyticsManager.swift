//
//  AnalyticsManager.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/3/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

final class AnalyticsManager: ObservableObject {
    private let service: AnalyticsServiceProtocol

    init(service: AnalyticsServiceProtocol) {
        self.service = service
    }

    func log(event: AnalyticsEvent) {
        service.send(event: event.name, metadata: event.metadata)
    }
}
