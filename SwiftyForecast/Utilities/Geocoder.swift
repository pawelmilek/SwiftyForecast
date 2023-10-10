import Foundation
import CoreLocation

final class Geocoder {

    class func fetchPlacemark(at location: CLLocation) async throws -> CLPlacemark {
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(location)

        if let placemark = placemarks.first {
            return placemark
        } else {
            throw GeocoderError.placemarkNotFound
        }
    }

}
