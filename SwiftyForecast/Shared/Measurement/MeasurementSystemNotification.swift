//
//  MeasurementSystemNotification.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/29/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct MeasurementSystemNotification {
    private let didChangeMeasurementSystem = NSNotification.Name("didChangeMeasurementSystem")
    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }

    func post() {
        notificationCenter.post(
            name: didChangeMeasurementSystem,
            object: self
        )
    }

    func addObserver(_ observer: Any, selector: Selector) {
        notificationCenter.addObserver(
            observer,
            selector: selector,
            name: didChangeMeasurementSystem,
            object: nil
        )
    }

    func removeObserver() {
        notificationCenter.removeObserver(self)
    }
}
