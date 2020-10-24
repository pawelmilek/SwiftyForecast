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
  private let timeZoneLoader: TimeZoneLoader
  
  init(city: CityDTO, timeZoneLoader: TimeZoneLoader = TimeZoneLoader()) {
    self.city = city
    self.timeZoneLoader = timeZoneLoader
  }
  
  func loadTimeZone(completion: @escaping (Result<String, GeocoderError>) -> ()) -> UUID? {
    guard localTime == InvalidReference.notApplicable else {
      completion(.success(city.timeZoneIdentifier))
      return nil
    }
    
    let result = timeZoneLoader.load(for: (city.latitude, city.longitude)) { result in
      switch result {
      case .success(let timeZone):
        let realm = RealmProvider.core.realm
        let realmCities = try! City.fetchAll(in: realm).filter("compoundKey = %@", city.compoundKey)
        
        try! realm.write {
          if let realmCity = realmCities.first {
            realmCity.timeZoneIdentifier = timeZone.identifier
            completion(.success(timeZone.identifier))
          }
        }

      case .failure(let error):
        debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(error)")
      }
    }
    
    return result
  }
  
  func cancelLoad(_ uuid: UUID) {
    timeZoneLoader.cancel(uuid)
  }
}
