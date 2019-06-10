import Foundation

struct MoonPhase: Decodable {
  private let lunation: Float
  private enum CodingKeys: String, CodingKey {
    case lunation = "moonPhase"
  }
}

// MARK: - Icon
extension MoonPhase {
  
  var icon: NSAttributedString? {
    return MoonPhaseFontIcon.make(icon: description, font: 25)?.attributedIcon
  }
  
}

// MARK: - CustomStringConvertible protocol
extension MoonPhase: CustomStringConvertible {
  
  var description: String {
    switch self.lunation {
    case 0:
      return "New moon"
      
    case 0.01..<0.25:
      return "Waxing crescent"
      
    case 0.25:
      return "First quarter moon"
      
    case 0.26..<0.5:
      return "Waxing gibbous"
      
    case 0.5:
      return "Full moon"
      
    case 0.51..<0.75:
      return "Waning gibbous"
      
    case 0.75:
      return "Last quarter moon"
      
    case 0.76...1.0:
      return "Waning crescent"
      
    default:
      return "NA"
    }
  }
  
}
