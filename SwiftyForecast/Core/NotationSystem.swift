enum NotationSystem {
  static var selectedUnitNotation: UnitNotation {
    get {
      return UserDefaultsAdapter.unitNotation
    }
    
    set {
      if selectedUnitNotation != newValue {
        UserDefaultsAdapter.set(notation: newValue)
      }
    }
  }
}
