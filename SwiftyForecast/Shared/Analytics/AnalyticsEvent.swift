//
//  AnalyticsEvent.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/4/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

protocol AnalyticsEvent {
    var name: String { get }
    var metadata: [String: Any] { get }
}
