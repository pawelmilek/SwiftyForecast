import Foundation

final class SharedGroupContainer {
  private static let defaults = UserDefaults(suiteName: PathFinder.groupIdentifier)
  
  static var sharedCity: CityRealm? {
    get {
      guard let defaults = SharedGroupContainer.defaults else { return nil }
      guard let currentCityData = defaults.data(forKey: "currentCity") else { return nil }
      guard let currentCity = try? JSONDecoder().decode(CityRealm.self, from: currentCityData) else { return nil }
      return currentCity
    }
    
//    set {
//      guard let defaults = SharedGroupContainer.defaults,
//        let encodedCity = try? JSONEncoder().encode(newValue) else { return }
//      defaults.set(encodedCity, forKey: "currentCity")
//      defaults.synchronize()
//    }
  }
  
}
