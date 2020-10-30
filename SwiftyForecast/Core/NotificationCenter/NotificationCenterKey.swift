import Foundation

extension Notification.Name {
  static let applicationDidBecomeActive = Notification.Name("applicationDidBecomeActive")
  
  static let unitNotationDidChange = Notification.Name("unitNotationDidChange")
  
  static let refreshButtonDidPress = Notification.Name("refreshButtonDidPress")
  static let reloadContentPageData = Notification.Name("reloadContentPageData")
  
  static let addCityFromCallout = Notification.Name("AddCityFromCallout")
  static let cityRemovedFromLocationList = Notification.Name("cityRemovedFromLocationList")
  
  static let locationProviderDidFail = Notification.Name("locationProviderDidFail")
  static let locationServicesDisabled = Notification.Name("locationServicesDisabled")
  static let locationServiceDidRequestLocation = Notification.Name("locationServiceDidRequestLocation")
}
