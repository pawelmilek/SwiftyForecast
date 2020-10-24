import MapKit

protocol CityCellViewModel {
  var name: String { get }
  var localTime: String { get }
  var miniMapData: (annotation: MKPointAnnotation, region: MKCoordinateRegion)? { get }
  var onSuccessTimeZoneGecoded: (() -> Void)? { get set }
  
  init(city: CityDTO, timeZoneLoader: TimeZoneLoader)
  
  func loadTimeZone(completion: @escaping (Result<String, GeocoderError>) -> ()) -> UUID?
  func cancelLoad(_ uuid: UUID)
}
