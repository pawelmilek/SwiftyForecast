extension Double {
  
  func ToFahrenheit() -> Double {
    let measurement = TemperatureMeasurement(value: self, unit: .celsius)
    let result = measurement.converted(to: .fahrenheit)
    return result
  }
  
}
