import UIKit
import MapKit

protocol AddCalloutViewModel {
  var cityName: String { get }
  var country: String { get }
  
  init(placemark: MKPlacemark)
  
  func add(completion: (Result<City, RealmError>) -> Void)
}
