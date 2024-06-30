//
//  MetricSystemNotification.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 6/24/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

protocol MetricSystemNotification {
    func post()
    func publisher() -> NotificationCenter.Publisher
}
