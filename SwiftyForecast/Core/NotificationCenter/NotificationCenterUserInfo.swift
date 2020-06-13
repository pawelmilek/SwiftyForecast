enum NotificationCenterUserInfo {
  case segmentedControlChanged
  
  var key: String {
    switch self {
    case .segmentedControlChanged:
      return "SegmentedControlChange"
    }
  }
}
