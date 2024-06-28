//
//  NotificationCenterAdapter.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/29/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

protocol MetricSystemNotification {
    func post()
    func publisher() -> NotificationCenter.Publisher
}

struct MetricSystemNotificationCenterAdapter: MetricSystemNotification {
    private static let didChangeMetricSystem = NSNotification.Name("didChangeMetricSystem")
    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    func post() {
        notificationCenter.post(
            name: Self.didChangeMetricSystem,
            object: self
        )
    }

    func publisher() -> NotificationCenter.Publisher {
        notificationCenter.publisher(for: Self.didChangeMetricSystem)
    }
}
