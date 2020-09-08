import Foundation
import RealmSwift

protocol CityDAO {
  func getAll() -> Results<City>?
  func getAll() -> [City]
  func get(latitude: Double, longitude: Double) -> City?
  func put(_ city: City, id: Int)
  func put(_ city: City)
  func delete(_ city: City) throws
  func deleteAll()
}
