import Foundation

final class AppStoreReviewObserver {
  weak var eventResponder: AppStoreReviewObserverEventResponder? {
    didSet {
      if eventResponder == nil {
        stopObserving()
      }
    }
  }
  
  private var isObserving = false
  
  @objc func desirableMomentDidHappen(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let rawValue = userInfo[AppStoreReviewUserInfoKey.desirableMoment] as? Int else { return }
    let enjoyableOutsideTemperature = userInfo[AppStoreReviewUserInfoKey.enjoyableOutsideTemperature] as? Int ?? 0
    
    var desirableMoment: ReviewDesirableMomentType {
      switch rawValue {
      case ReviewDesirableMomentType.locationAdded.key:
        return .locationAdded
        
      case ReviewDesirableMomentType.detailsInteractionExpanded.key:
        return .detailsInteractionExpanded
        
      case ReviewDesirableMomentType.enjoyableOutsideTemperatureReached(value: enjoyableOutsideTemperature).key:
        return .enjoyableOutsideTemperatureReached(value: enjoyableOutsideTemperature)
        
      default:
        return .detailsInteractionExpanded
      }
    }
    
    eventResponder?.appStoreReviewDesirableMomentDidHappen(desirableMoment)
  }
}


// MARK: - Observer protocol
extension AppStoreReviewObserver: Observer {
  
  func startObserving() {
    guard !isObserving else { return }

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(desirableMomentDidHappen),
                                           name: .appStoreDesirableMomentHappen,
                                           object: nil)
    isObserving = true
  }
  
  func stopObserving() {
    NotificationCenter.default.removeObserver(self)
    isObserving = false
  }
  
}
