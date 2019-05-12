enum GooglePlacesError: ErrorHandleable {
  case placeNotFound
  case locationDisabled
}

// MARK: - ErrorHandleable protocol
extension GooglePlacesError {
  
  var description: String {
    switch self {
    case .placeNotFound:
      return "Google Places did not find a place."
      
    case .locationDisabled:
      return "Location disabled. Please, check settings."
    }
  }
  
}
