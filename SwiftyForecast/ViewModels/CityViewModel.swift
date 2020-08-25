import MapKit

protocol CityViewModel {
  var name: String { get }
  var localTime: String { get }
  var map: (annotation: MKPointAnnotation, region: MKCoordinateRegion)? { get }
  
  init(city: City)
}
