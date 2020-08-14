import MapKit

struct DefaultCityViewModel: CityViewModel {
  var name: String {
    return city.name + ", " + city.country
  }

  var localTime: String {
    guard city.localTime == InvalidReference.notApplicable else {
      return city.localTime
    }
    
    if let coordinate = city.location?.coordinate {
      fetchTimeZone(for: coordinate) { timeZone in
        return timeZone?.identifier ?? "dafd"
      }
    }
    
    return InvalidReference.notApplicable
    
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

// MARK: - Private - Fetch local time
private extension DefaultCityViewModel {

  func fetchTimeZone(for location: CLLocationCoordinate2D, completion: @escaping (_ timeZone: TimeZone?) -> ()) {
    GeocoderHelper.timeZone(for: location) { result in
      switch result {
      case .success(let data):
        completion(data)

      case .failure:
        completion(nil)
      }
    }
  }

}
