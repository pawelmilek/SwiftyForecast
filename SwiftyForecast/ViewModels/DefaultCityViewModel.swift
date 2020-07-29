import MapKit

struct DefaultCityViewModel: CityViewModel {
  var name: String {
    return city.name + ", " + city.country
  }

  var localTime: String {
    return city.localTime
  }
  
  var map: (annotation: MKPointAnnotation, region: MKCoordinateRegion)? {
    guard let placemark = city.placemark else { return nil }
    
    let mkPlacemark = MKPlacemark(placemark: placemark)
    let annotation = MKPointAnnotation()
    annotation.coordinate = mkPlacemark.coordinate
    annotation.title = mkPlacemark.name
    if let city = mkPlacemark.locality, let state = mkPlacemark.administrativeArea {
      annotation.subtitle = "\(city) \(state)"
    }

    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    let region = MKCoordinateRegion(center: mkPlacemark.coordinate, span: span)
    return (annotation: annotation, region: region)
  }
  
  private let city: City
  
  init(city: City) {
    self.city = city
  }
}
