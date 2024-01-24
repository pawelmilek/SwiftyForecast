//
//  ReviewNotificationCenter.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct ReviewNotificationCenter {
    enum InfoKey {
        static let desirableMoment = "AppStoreReviewDesirableMoment"
        static let enjoyableOutsideTemperature = "EnjoyableOutsideTemperature"
    }

    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }

    func post(_ type: ReviewDesirableMomentType, object: Any? = nil) {
        notificationCenter.post(
            name: .didRequestAppStoreReview,
            object: object,
            userInfo: [InfoKey.desirableMoment: type]
        )
    }
}
