import UIKit
import MapKit

protocol AddCalloutViewModel {
  var cityName: String { get }
  var country: String { get }
  
  init(placemark: MKPlacemark, dataAccessObject: CityDAO, modelTranslator: ModelTranslator)
  
  func add(completion: (Result<CityDTO, RealmError>) -> Void)
}
