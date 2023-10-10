import Foundation

struct AppStoreReviewCenter {
    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }

    func post(_ type: ReviewDesirableMomentType, object: Any? = nil) {
        notificationCenter.post(
            name: .appStoreDesirableMomentHappen,
            object: object,
            userInfo: [AppStoreReviewUserInfoKey.desirableMoment: type]
        )
    }
}
