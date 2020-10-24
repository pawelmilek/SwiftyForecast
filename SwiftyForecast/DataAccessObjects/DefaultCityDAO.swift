import Foundation
import RealmSwift

struct DefaultCityDAO: CityDAO {
  func getAllResultOrderedByIndex() -> Results<City>? {
    return try? City.fetchAllOrderedByIndex()
  }
  
  func getAllOrderedByIndex() -> [City] {
    guard let all = try? City.fetchAllOrderedByIndex() else { return [] }
    return Array(all)
  }
  
  func put(_ city: City, sortIndex: Int) throws {
    try City.add(city, sortIndex: sortIndex)
  }
  
  func put(_ city: City) throws {
    try City.add(city)
  }
  
  func delete(_ city: City) throws {
    try city.delete()
  }
  
  func deleteAll() throws {
    try! City.deleteAll()
  }
}
