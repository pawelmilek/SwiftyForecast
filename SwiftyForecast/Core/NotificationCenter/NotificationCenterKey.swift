import Foundation

public extension Notification.Name {
  static let unitNotationDidChange = Notification.Name("unitNotationDidChange")
  static let refreshButtonDidPress = Notification.Name("refreshButtonDidPress")
  static let reloadContentPageData = Notification.Name("reloadContentPageData")
  static let addCityFromCallout = Notification.Name("AddCityFromCallout")
  static let locationServiceDidRequestLocation = Notification.Name("locationServiceDidRequestLocation")
  static let locationRemovedFromList = Notification.Name("locationRemovedFromList")
  static let applicationDidBecomeActive = Notification.Name("applicationDidBecomeActive")
}
