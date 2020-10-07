import Foundation
import MapKit

struct CityDTO {
  let compoundKey: String
  let name: String
  let country: String
  let state: String
  let postalCode: String
  let timeZoneIdentifier: String
  let lastUpdate: Date
  let isUserLocation: Bool
  let latitude: Double
  let longitude: Double
  let placemark: CLPlacemark
  let localTime: String
}
