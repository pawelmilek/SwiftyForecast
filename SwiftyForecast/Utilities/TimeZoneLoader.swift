import MapKit

class TimeZoneLoader: TimeZoneLoadable {
  private var loadedTimeZones = [String: TimeZone]()
  private var runningRequests = [UUID: CLGeocoder]()
  
  func load(for coordinate: Location, completion: @escaping (Result<TimeZone, GeocoderError>) -> ()) -> UUID? {
    let key = "\(coordinate.latitude)|\(coordinate.longitude)"

    if let timeZone = loadedTimeZones[key] {
      completion(.success(timeZone))
      return nil
    }
    
    let uuid = UUID()
    let location = CLLocation(latitude: CLLocationDegrees(coordinate.latitude),
                              longitude: CLLocationDegrees(coordinate.longitude))
    
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
      defer { self.runningRequests.removeValue(forKey: uuid) }
      
      guard let placemark = placemarks?.first, let timezone = placemark.timeZone, error == nil else {
        completion(.failure(GeocoderError.timezoneNotFound))
        return
      }
      
      self.loadedTimeZones[key] = timezone
      completion(.success(timezone))
    }
    
    runningRequests[uuid] = geocoder
    return uuid
  }
  
  func cancel(_ uuid: UUID) {
    runningRequests[uuid] = nil
    runningRequests.removeValue(forKey: uuid)
  }
}
