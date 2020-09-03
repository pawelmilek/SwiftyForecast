import Foundation
import RealmSwift

struct ForecastDataStorage: DataStorage {
  func get(latitude: Double, longitude: Double) -> ForecastResponse? {
    let forecast = try? ForecastResponse.fetchAll().filter("longitude = %@ AND latitude = %@", longitude, latitude).first
    return forecast
  }
  
  func put(data: ForecastResponse) {
    try! ForecastResponse.add(data)
  }
}
