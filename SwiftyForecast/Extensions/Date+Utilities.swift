import UIKit

extension Date {
  
  static func minutesBetweenDates(from oldDate: Date, to newDate: Date) -> Int? {
    let minutes = Calendar.current.dateComponents([.minute], from: oldDate, to: newDate).minute
    return minutes
  }
  
  func toString(withFormat format: String = "yyyy-MM-dd HH:mm") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = format
    let dateString = dateFormatter.string(from: self)
    return dateString
  }
  
}
