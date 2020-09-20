enum NotificationCenterUserInfo: String {
  case segmentedControlChanged
  case cityUpdatedAtIndex
  case cityUpdated
  
  var key: String {
    return self.rawValue
  }
}
