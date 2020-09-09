import Foundation
import RealmSwift

protocol CityDAO {
  func getAll() -> Results<City>?
  func getAll() -> [City]
  func get(latitude: Double, longitude: Double) -> City?
  func put(_ city: City, id: Int) throws
  func put(_ city: City) throws
  func delete(_ city: City) throws
  func deleteAll() throws
}
