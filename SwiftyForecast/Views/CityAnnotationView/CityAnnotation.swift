import UIKit
import MapKit

final class CityAnnotation: NSObject, MKAnnotation {
  var city: City
  var coordinate: CLLocationCoordinate2D {
    let latitude = city.location?.coordinate.latitude ?? 0
    let longitude = city.location?.coordinate.longitude ?? 0
    let coordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    return coordinate2D
  }
  
  init(city: City) {
    self.city = city
    super.init()
  }
  
  var title: String? {
    return city.name
  }
  
  var subtitle: String? {
    return city.country
  }
}
