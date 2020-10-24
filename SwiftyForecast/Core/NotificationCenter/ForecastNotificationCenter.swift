import Foundation

final class ForecastNotificationCenter {
  
  static func add(observer: Any, selector: Selector, for name: Notification.Name, object: Any? = nil) {
    NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
  }
  
  static func remove(observer: Any) {
    NotificationCenter.default.removeObserver(observer)
  }
  
  static func post(_ name: Notification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
    NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
  }
  
}
