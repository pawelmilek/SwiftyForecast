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
    fetchTimeZone(for: city)
  }
}

// MARK: - Private - Fetch local time
private extension DefaultCityViewModel {

  func fetchTimeZone(for city: City) {
    guard city.timeZoneName == InvalidReference.notApplicable else { return }
    guard let coordinate = city.location?.coordinate else { return }
    
    GeocoderHelper.timeZone(for: coordinate) { result in
      switch result {
      case .success(let data):
        let realm = RealmProvider.core.realm
        
        try! realm.write {
          city.timeZoneName = data.identifier
        }

      case .failure:
        break
      }
    }
  }

}
