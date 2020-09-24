import Foundation
import RealmSwift

struct DefaultCityDAO: CityDAO {
  func getAll() -> Results<City>? {
    return try? City.fetchAllOrderedByIndex()
  }
  
  func getAll() -> [City] {
    guard let all = try? City.fetchAllOrderedByIndex() else { return [] }
    return Array(all)
  }

  func get(latitude: Double, longitude: Double) -> City? {
    let compoundKey = "\(latitude)|\(longitude)"
    let city = try? City.fetchAll().filter("compoundKey = %@", compoundKey).first
    return city
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
