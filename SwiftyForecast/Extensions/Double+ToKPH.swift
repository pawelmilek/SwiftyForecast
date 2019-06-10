extension Double {
  
  func toKPH() -> Double {
    let oneMileEqualKilometerPerHour = 1.609344
    return self * oneMileEqualKilometerPerHour
  }
  
}
