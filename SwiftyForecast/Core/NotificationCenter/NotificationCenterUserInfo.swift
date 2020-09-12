enum NotificationCenterUserInfo: String {
  case segmentedControlChanged
  case cityListUpdated
  
  var key: String {
    return self.rawValue
  }
}
