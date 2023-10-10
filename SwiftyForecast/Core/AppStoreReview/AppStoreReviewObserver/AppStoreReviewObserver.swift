import Foundation

protocol Observer {
    func startObserving()
    func stopObserving()
}

final class AppStoreReviewObserver {
    weak var eventResponder: AppStoreReviewObserverEventResponder? {
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
              let desirableMoment = userInfo[AppStoreReviewUserInfoKey.desirableMoment]
                as? ReviewDesirableMomentType else { return }

        eventResponder?.appStoreReviewDesirableMomentDidHappen(desirableMoment)
    }
}

// MARK: - Observer protocol
extension AppStoreReviewObserver: Observer {

    func startObserving() {
        guard !isObserving else { return }

        notificationCenter.addObserver(self,
                                       selector: #selector(desirableMomentDidHappen),
                                       name: .appStoreDesirableMomentHappen,
                                       object: nil)
        isObserving = true
    }

    func stopObserving() {
        notificationCenter.removeObserver(self)
        isObserving = false
    }

}
