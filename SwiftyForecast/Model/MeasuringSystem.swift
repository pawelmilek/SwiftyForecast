enum MeasuringSystem {
  case metric
  case imperial
  
  static var value: MeasuringSystem = .imperial {
    didSet {
      if oldValue != value {
        
      }
    }
  }
  
  static var selected: MeasuringSystem = .imperial
}
