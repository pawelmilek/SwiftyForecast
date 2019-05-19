enum SegmentedControlItem: CaseIterable {
  case fahrenheit
  case celsius
}

// MARK: - CustomStringConvertible protocol
extension SegmentedControlItem: CustomStringConvertible {
  
  var description: String {
    switch self {
    case .fahrenheit:
      return Style.fahrenheitDegree
      
    case .celsius:
      return Style.celsiusDegree
    }
  }
}
