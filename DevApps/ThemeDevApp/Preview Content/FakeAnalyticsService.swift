//
//  FakeAnalyticsService.swift
//  ThemeDevApp
//
//  Created by Pawel Milek on 7/3/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import ThemeFeatureDomain

final class FakeAnalyticsService: AnalyticsService {
    func send(event: AnalyticsEvent) { }
}
