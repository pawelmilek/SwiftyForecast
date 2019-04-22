import Foundation

enum GeocoderError: ErrorHandleable {
  case coordinateNotFound
  case placeNotFound
  case locationDisabled
  case timezoneNotFound
}


// MARK: - ErrorHandleable protocol
extension GeocoderError {
  
  var description: String {
    switch self {
    case .coordinateNotFound:
      return "Geocoder did not find a coordinate."
      
    case .placeNotFound:
      return "Geocoder did not find a place."
      
    case .locationDisabled:
      return "Location disabled. Please, check settings."
      
    case .timezoneNotFound:
      return "Geocoder did not find a timezone."
    }
  }
  
}
