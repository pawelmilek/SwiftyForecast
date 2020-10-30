import Foundation

final class NotationController {
  lazy var unitNotation = loadUnitNotation() {
    didSet { saveUnitNotation() }
  }
  
  lazy var temperatureNotation = loadTemperatureNotation() {
    didSet { saveTemperatureNotation() }
  }
  
  private let storage: UserDefaults
  
  init(storage: UserDefaults = .standard) {
    self.storage = storage
  }
  
  private func loadUnitNotation() -> UnitNotation {
    let storedValue = storage.integer(forKey: NotationType.unit.key)
    return UnitNotation(rawValue: storedValue) ?? .imperial
  }
  
  private func saveUnitNotation() {
    storage.set(unitNotation.rawValue, forKey: NotationType.unit.key)
  }
  
  private func loadTemperatureNotation() -> TemperatureNotation {
    let storedValue = storage.integer(forKey: NotationType.temperature.key)
    return TemperatureNotation(rawValue: storedValue) ?? .fahrenheit
  }
  
  private func saveTemperatureNotation() {
    storage.set(temperatureNotation.rawValue, forKey: NotationType.temperature.key)
  }
}
