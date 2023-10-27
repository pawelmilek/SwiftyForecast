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

protocol Observer {
    var eventResponder: ReviewObserverEventResponder? { get set }
    func startObserving()
    func stopObserving()
}

final class ReviewObserver: Observer {
    weak var eventResponder: ReviewObserverEventResponder? {
        didSet {
            if eventResponder == nil {
                stopObserving()
            }
        }
    }

    private var isObserving = false
    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }

    @objc func desirableMomentDidHappen(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let desirableMoment = userInfo[ReviewNotificationCenter.InfoKey.desirableMoment]
                as? ReviewDesirableMomentType else { return }

        eventResponder?.reviewDesirableMomentDidHappen(desirableMoment)
    }
}

// MARK: - Observer protocol
extension ReviewObserver {

    func startObserving() {
        guard !isObserving else { return }

        notificationCenter.addObserver(
            self,
            selector: #selector(desirableMomentDidHappen),
            name: .appStoreDesirableMomentHappen,
            object: nil
        )
        isObserving = true
    }

    func stopObserving() {
        notificationCenter.removeObserver(self)
        isObserving = false
    }

}
