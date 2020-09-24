import UIKit
import MapKit

protocol MapCalloutViewModel {
  var cityName: String { get }
  var country: String { get }
  
  init(placemark: MKPlacemark,
       delegate: MapCalloutViewControllerDelegate?,
       dataAccessObject: CityDAO,
       modelTranslator: ModelTranslator)
  
  func addCityToLocationList()
}
