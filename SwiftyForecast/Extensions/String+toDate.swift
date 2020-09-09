import Foundation

extension String {
  
  func toDate(withFormat format: String = "yyyy-MM-dd HH:mm")-> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = format
    let date = dateFormatter.date(from: self)
    return date
  }
  
}
