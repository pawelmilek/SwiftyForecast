import Foundation

final class NotificationAdapter {
  private static let shared = NotificationCenter.default
  
  static func add(observer: Any, selector: Selector, for name: Notification.Name, object: Any? = nil) {
    shared.addObserver(observer, selector: selector, name: name, object: object)
  }
  
  static func remove(observer: Any) {
    shared.removeObserver(observer)
  }
  
  static func post(_ name: Notification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
    shared.post(name: name, object: object, userInfo: userInfo)
  }
  
}
