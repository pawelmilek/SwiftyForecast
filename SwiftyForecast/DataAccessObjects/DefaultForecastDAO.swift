import Foundation
import RealmSwift

struct DefaultForecastDAO: ForecastDAO {  
  func get(latitude: Double, longitude: Double) -> ForecastResponse? { // "51.110124|17.032161"
    let compoundKey = "\(latitude)|\(longitude)"
    let forecast = try? ForecastResponse.fetchAll().filter("compoundKey = %@", compoundKey).first
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
