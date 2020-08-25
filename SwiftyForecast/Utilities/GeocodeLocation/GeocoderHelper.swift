import Foundation
import CoreLocation

final class GeocoderHelper {
  
  class func currentLocation(completion: @escaping (Result<CLPlacemark, GeocoderError>) -> ()) {
    guard LocationProvider.shared.isLocationServicesEnabled else {
      completion(.failure(.locationDisabled))
      return
    }
    
    LocationProvider.shared.requestLocation { location in
      GeocoderHelper.place(at: location.coordinate) { result in
        switch result {
        case .success(let data):
          completion(.success(data))
          
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
  }
  
  class func coordinate(by address: String, completionHandler: @escaping (Result<CLLocationCoordinate2D, GeocoderError>) -> ()) {
    CLGeocoder().geocodeAddressString(address) { placemarks, error in
      guard let placemark = placemarks?.last,
            let coordinate = placemark.location?.coordinate, error == nil else {
          completionHandler(.failure(GeocoderError.coordinateNotFound))
          return
      }
      
      completionHandler(.success(coordinate))
    }
  }
  
  class func place(at coordinate: CLLocationCoordinate2D, completionHandler: @escaping (Result<CLPlacemark, GeocoderError>) -> ()) {
    let location = CLLocation(latitude: CLLocationDegrees(coordinate.latitude),
                              longitude: CLLocationDegrees(coordinate.longitude))
    CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
      guard let placemark = placemarks?.first, error == nil else {
        completionHandler(.failure(GeocoderError.placeNotFound))
        return
      }
      
      completionHandler(.success(placemark))
    }
  }
  
  class func timeZone(for coordinate: CLLocationCoordinate2D, completionHandler: @escaping (Result<TimeZone, GeocoderError>) -> ()) {
    let location = CLLocation(latitude: CLLocationDegrees(coordinate.latitude),
                              longitude: CLLocationDegrees(coordinate.longitude))
    CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
      guard let placemark = placemarks?.first,
            let timezone = placemark.timeZone, error == nil else {
          completionHandler(.failure(GeocoderError.timezoneNotFound))
          return
      }
      
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(timezone)")
      completionHandler(.success(timezone))
    }
  }
}
