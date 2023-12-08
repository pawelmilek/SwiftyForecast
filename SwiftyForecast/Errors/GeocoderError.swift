enum GeocoderError: Error {
    case coordinateNotFound
    case placemarkNotFound
    case locationDisabled
    case timezoneNotFound
}

// MARK: - ErrorHandleable protocol
extension GeocoderError {

    var errorDescription: String? {
        switch self {
        case .coordinateNotFound:
            return "Geocoder failed to find a coordinate."

        case .placemarkNotFound:
            return "Geocoder failed to find a placemark."

        case .locationDisabled:
            return "Location disabled. Please, check settings."

        case .timezoneNotFound:
            return "Geocoder did not find a timezone."
        }
    }

}
