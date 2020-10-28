import Foundation

protocol TimeZoneLoadable {
  typealias Location = (latitude: Double, longitude: Double)
  
  func load(for coordinate: Location, completion: @escaping (Result<TimeZone, GeocoderError>) -> ()) -> UUID?
  func cancel(_ uuid: UUID)
}
