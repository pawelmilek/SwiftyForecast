import Foundation

struct UserDefaultsAdapter {
  
  static var unitNotation: UnitNotation {
    let storedValue = UserDefaults.standard.integer(forKey: UserDefaultsKeys.unitsNotation.rawValue)
    return UnitNotation(rawValue: storedValue) ?? .imperial
  }
  
  static var temperatureNotation: TemperatureNotation {
    let storedValue = UserDefaults.standard.integer(forKey: UserDefaultsKeys.temperatureNotation.rawValue)
    return TemperatureNotation(rawValue: storedValue) ?? .fahrenheit
  }
  
  static func set(notation: UnitNotation) {
    UserDefaults.standard.set(notation.rawValue, forKey: UserDefaultsKeys.unitsNotation.rawValue)
    
    switch notation {
    case .imperial:
      setTemperature(notation: .fahrenheit)
      
    case .metric:
      setTemperature(notation: .celsius)
    }
  }
  
  static func resetNotation() {
    UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.unitsNotation.rawValue)
  }
}

// MARK: - Private - Set unit and temerature notation
private extension UserDefaultsAdapter {

  static func setUnit(notation: UnitNotation) {
    UserDefaults.standard.set(notation.rawValue, forKey: UserDefaultsKeys.unitsNotation.rawValue)
  }
  
  static func setTemperature(notation: TemperatureNotation) {
    UserDefaults.standard.set(notation.rawValue, forKey: UserDefaultsKeys.temperatureNotation.rawValue)
  }
  
}
