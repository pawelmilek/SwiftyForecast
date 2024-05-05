//
//  ReviewObserver.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

protocol ReviewObserverEventResponder: AnyObject {
    func reviewDesirableMomentDidHappen(_ desirableMoment: ReviewDesirableMomentType)
}

final class ReviewObserver {
    private weak var eventResponder: ReviewObserverEventResponder?
    private let notificationCenter: NotificationCenter

    init(
        eventResponder: ReviewObserverEventResponder?,
        notificationCenter: NotificationCenter
    ) {
        self.eventResponder = eventResponder
        self.notificationCenter = notificationCenter
    }

    func start() {
        notificationCenter.addObserver(
            self,
            selector: #selector(desirableMomentDidHappen),
            name: .didRequestAppStoreReview,
            object: nil
        )
    }

    func stop() {
        notificationCenter.removeObserver(self)
    }

    @objc func desirableMomentDidHappen(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let desirableMoment = userInfo[ReviewNotificationCenter.InfoKey.desirableMoment]
                as? ReviewDesirableMomentType else { return }

        eventResponder?.reviewDesirableMomentDidHappen(desirableMoment)
    }
}
