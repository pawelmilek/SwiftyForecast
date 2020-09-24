import MapKit

struct DefaultCityCellViewModel: CityCellViewModel {
  var name: String {
    return city.name + ", " + city.country
  }

  var localTime: String {
    return city.localTime
  }
  
  var onSuccessTimeZoneGecoded: (() -> Void)?
  
  var miniMapData: (annotation: MKPointAnnotation, region: MKCoordinateRegion)? {
    let mkPlacemark = MKPlacemark(placemark: city.placemark)
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
  
  private let city: CityDTO
  
  init(city: CityDTO) {
    self.city = city
    fetchTimeZone(for: city)
  }
}

// MARK: - Private - Fetch local time
private extension DefaultCityCellViewModel {

  // TODO: Improve time zone fetching. Prevent multiple executions
  func fetchTimeZone(for city: CityDTO) {
    guard city.timeZoneName == InvalidReference.notApplicable else { return }
    let coordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
    
    GeocoderHelper.timeZone(for: coordinate) { result in
      switch result {
      case .success(let data):
        let realm = RealmProvider.core.realm
        
        try! realm.write {
          let realmCity = ModelTranslator().translate(dto: city)
          realmCity.timeZoneName = data.identifier
        }

      case .failure(let error):
        debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(error)")
      }
    }
  }

}
