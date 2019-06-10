import Foundation

struct ForecastUserDefaults {
  
  static var unitNotation: UnitNotation {
    let storedValue = UserDefaults.standard.integer(forKey: UserDefaultsKeys.unitsNotation.rawValue)
    return UnitNotation(rawValue: storedValue) ?? .imperial
  }
  
  static func setUnit(notation: UnitNotation) {
    UserDefaults.standard.set(notation.rawValue, forKey: UserDefaultsKeys.unitsNotation.rawValue)
  }
  
  static func setTemperature(notation: TemperatureNotation) {
    UserDefaults.standard.set(notation.rawValue, forKey: UserDefaultsKeys.temperatureNotation.rawValue)
  }
  
  static var temperatureNotation: TemperatureNotation {
    let storedValue = UserDefaults.standard.integer(forKey: UserDefaultsKeys.temperatureNotation.rawValue)
    return TemperatureNotation(rawValue: storedValue) ?? .fahrenheit
  }
  
}
