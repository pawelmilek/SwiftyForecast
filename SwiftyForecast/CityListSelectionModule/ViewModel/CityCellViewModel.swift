import MapKit

protocol CityCellViewModel {
  var name: String { get }
  var localTime: String { get }
  var miniMapData: (annotation: MKPointAnnotation, region: MKCoordinateRegion)? { get }
  var onSuccessTimeZoneGecoded: (() -> Void)? { get set }
  
  init(city: CityDTO)
}
