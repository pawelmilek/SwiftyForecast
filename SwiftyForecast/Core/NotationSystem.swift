enum NotationSystem {
  static var selectedUnitNotation: UnitNotation {
    get {
      return ForecastUserDefaults.unitNotation
    }
    
    set {
      if selectedUnitNotation != newValue {
        ForecastUserDefaults.set(notation: newValue)
      }
    }
  }
}
