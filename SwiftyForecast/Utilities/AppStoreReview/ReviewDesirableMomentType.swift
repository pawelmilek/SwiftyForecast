enum ReviewDesirableMomentType {
  case locationAdded
  case detailsInteractionExpanded
  case enjoyableOutsideTemperatureReached(value: Int)
  
  var key: Int {
    switch self {
    case .locationAdded:
      return 0
      
    case .detailsInteractionExpanded:
      return 1
      
    case .enjoyableOutsideTemperatureReached:
      return 2
    }
  }
}
