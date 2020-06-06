import Foundation

struct DistanceMeasurement {
  var value: Double {
    measurement.value
  }
  
  private let measurement: Measurement<UnitLength>
  
  init(value: Double, unit: UnitLength) {
    measurement = Measurement(value: value, unit: unit)
  }

  func converted(to: UnitLength) -> Double {
    let result = measurement.converted(to: to)
    return result.value
  }
}
