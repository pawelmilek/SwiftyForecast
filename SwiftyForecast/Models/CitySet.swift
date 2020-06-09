import Foundation
import RealmSwift

@objcMembers class CitySet: Object {
  let cities = List<City>()

  convenience init(cities: [City]) {
    self.init()
    self.cities.append(objectsIn: cities)
  }

  func append(objectsIn entries: [City]) {
    cities.append(objectsIn: entries)
  }
}
