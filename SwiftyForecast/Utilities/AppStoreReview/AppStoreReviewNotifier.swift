import Foundation

enum AppStoreReviewNotifier {
  static func notify(_ type: ReviewDesirableMomentType, object: Any? = nil) {
    var userInfo: [String: Int] {
      switch type {
      case .locationAdded, .detailsInteractionExpanded:
        return [AppStoreReviewUserInfoKey.desirableMoment: type.key]
        
      case .enjoyableOutsideTemperatureReached(let value):
        return [AppStoreReviewUserInfoKey.desirableMoment: type.key,
                AppStoreReviewUserInfoKey.enjoyableOutsideTemperature: value]
      }
    }

    NotificationCenter.default.post(name: .appStoreDesirableMomentHappen, object: object, userInfo: userInfo)
  }
}
