import Foundation
import CoreLocation
import RealmSwift

struct ForecastDAO {

  func hasValidData(interval: TimeInterval) -> Bool {
    return false
  }

  func get(for location: CLLocation) -> ForecastResponse? {
    let forecast = try? ForecastResponse.fetchAll().filter("longitude = %@ AND latitude = %@",
                                                           location.coordinate.longitude,
                                                           location.coordinate.latitude).first
    return forecast
  }
  
  func put(data: ForecastResponse) {
    try! ForecastResponse.add(data)
  }
}
