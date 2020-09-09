import Foundation
import RealmSwift

struct DefaultForecastDAO: ForecastDAO {  
  func get(latitude: Double, longitude: Double) -> ForecastResponse? {
    let forecast = try? ForecastResponse.fetchAll().filter("longitude = %@ AND latitude = %@", longitude, latitude).first
    return forecast
  }
  
  func put(_ forecast: ForecastResponse) {
    try! ForecastResponse.add(forecast)
  }
  
  func delete(_ forecast: ForecastResponse) throws {
    try forecast.delete()
  }
  
  func deleteAll() throws {
    try ForecastResponse.deleteAll()
  }
}
