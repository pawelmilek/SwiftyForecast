import Foundation

struct CityDTO {
  let id: Int
  let name: String
  let country: String
  let state: String
  let postalCode: String
  let timeZoneName: String
  let lastUpdate: Date
  let isUserLocation: Bool
  let location: LocationDTO
}
