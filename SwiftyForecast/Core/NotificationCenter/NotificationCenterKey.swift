import Foundation

public extension Notification.Name {
  static let unitNotationDidChange = Notification.Name("unitNotationDidChange")
  static let refreshButtonDidPress = Notification.Name("refreshButtonDidPress")
  static let reloadPages = Notification.Name("reloadPages")
  static let reloadPagesData = Notification.Name("reloadPagesData")
  static let locationServiceDidRequestLocation = Notification.Name("locationServiceDidRequestLocation")
  static let applicationDidBecomeActive = Notification.Name("applicationDidBecomeActive")
}
