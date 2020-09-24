enum NotificationCenterUserInfo: String {
  case segmentedControlChanged
  case cityUpdatedAtIndex
  case cityUpdated
  case cityAdded
  
  var key: String {
    return self.rawValue
  }
}
