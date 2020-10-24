import Foundation
import RealmSwift

protocol CityDAO {
  func getAllResultOrderedByIndex() -> Results<City>?
  func getAllOrderedByIndex() -> [City]
  func put(_ city: City, sortIndex: Int) throws
  func put(_ city: City) throws
  func delete(_ city: City) throws
  func deleteAll() throws
}
