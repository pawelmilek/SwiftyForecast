import Foundation
import RealmSwift

struct DefaultForecastDAO: ForecastDAO {
  func get(latitude: Double, longitude: Double) -> ForecastResponse? {
    let forecast = try? ForecastResponse.fetchAll().filter("longitude = %@ AND latitude = %@", longitude, latitude).first
    return forecast
  }
  
  func put(data: ForecastResponse) {
    try! ForecastResponse.add(data)
  }
  
  func delete(forecast: ForecastResponse) {
    try! forecast.delete()
  }
  
  func deleteAll() {
    try! ForecastResponse.deleteAll()
  }
}
