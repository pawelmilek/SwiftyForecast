import Foundation
import RealmSwift

struct DefaultCityDAO: CityDAO {
  func getAll() -> Results<City>? {
    return try! City.fetchAllOrdered()
  }
  
  func getAll() -> [City] {
    let all = try! City.fetchAllOrdered()
    return Array(all)
  }

  func get(latitude: Double, longitude: Double) -> City? {
    let city = try? City.fetchAll().filter("longitude = %@ AND latitude = %@", longitude, latitude).first
    return city
  }
  
  func put(_ city: City, id: Int) {
    try! City.add(city, withId: id)
  }
  
  func put(_ city: City) {
    try! City.add(city)
  }
  
  func delete(_ city: City) throws {
    try city.delete()
  }
  
  func deleteAll() {
    try! City.deleteAll()
  }
}
