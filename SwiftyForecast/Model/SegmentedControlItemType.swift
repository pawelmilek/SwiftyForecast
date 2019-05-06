enum SegmentedControlItemType: CaseIterable {
  case fahrenheit
  case celsius
}

// MARK: - CustomStringConvertible protocol
extension SegmentedControlItemType: CustomStringConvertible {
  
  var description: String {
    let degreeSign = "\u{00B0}"
    
    switch self {
    case .fahrenheit:
      return "\(degreeSign)F"
      
    case .celsius:
      return "\(degreeSign)C"
    }
  }
}
