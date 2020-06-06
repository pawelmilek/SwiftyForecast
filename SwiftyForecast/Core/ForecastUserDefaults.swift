import Foundation

struct ForecastUserDefaults {
  enum Key: String {
    case temperatureNotation
    case unitsNotation
    
    var value: String {
      return self.rawValue
    }
  }
  
  static var unitNotation: UnitNotation {
    let storedValue = UserDefaults.standard.integer(forKey: ForecastUserDefaults.Key.unitsNotation.value)
    return UnitNotation(rawValue: storedValue) ?? .imperial
  }
  
  static var temperatureNotation: TemperatureNotation {
    let storedValue = UserDefaults.standard.integer(forKey: ForecastUserDefaults.Key.temperatureNotation.value)
    return TemperatureNotation(rawValue: storedValue) ?? .fahrenheit
  }
  
  static func set(notation: UnitNotation) {
    UserDefaults.standard.set(notation.rawValue, forKey: ForecastUserDefaults.Key.unitsNotation.value)
    
    switch notation {
    case .imperial:
      setTemperature(notation: .fahrenheit)
      
    case .metric:
      setTemperature(notation: .celsius)
    }
  }
  
  static func resetNotation() {
    UserDefaults.standard.removeObject(forKey: ForecastUserDefaults.Key.unitsNotation.value)
  }
}

// MARK: - Private - Set unit and temerature notation
private extension ForecastUserDefaults {

  static func setUnit(notation: UnitNotation) {
    UserDefaults.standard.set(notation.rawValue, forKey: ForecastUserDefaults.Key.unitsNotation.value)
  }
  
  static func setTemperature(notation: TemperatureNotation) {
    UserDefaults.standard.set(notation.rawValue, forKey: ForecastUserDefaults.Key.temperatureNotation.value)
  }
  
}
