import UIKit
import MapKit

struct DefaultAddCalloutViewModel: AddCalloutViewModel {
  var cityName: String { city.name }
  var country: String { city.country }
  
  private let city: City

  init(placemark: MKPlacemark) {
    city = City(placemark: placemark)
    city.isUserLocation = false
  }
  
  func add(completion: (Result<City, RealmError>) -> Void) {
    do {
      let addedCity = try City.add(city)
      completion(.success(addedCity))
    } catch {
      completion(.failure(.transactionFailed(description: "Faild to write \(city)")))
    }
  }
}
