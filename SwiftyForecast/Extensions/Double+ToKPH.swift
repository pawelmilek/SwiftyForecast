extension Double {
  
  func toKPH() -> Double {
    let measurement = DistanceMeasurement(value: self, unit: .miles)
    let result = measurement.converted(to: .kilometers)
    return result
  }
  
}
