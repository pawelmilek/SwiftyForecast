import Foundation

extension DateFormatter {
  
  static func shortLocalTime(from timeZoneName: String) -> String {
    guard let timezone = NSTimeZone(name: timeZoneName) else { return "N/A" }
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    formatter.timeZone = timezone as TimeZone
    
    let localTime = formatter.string(from: Date())
    return localTime
  }
  
}
