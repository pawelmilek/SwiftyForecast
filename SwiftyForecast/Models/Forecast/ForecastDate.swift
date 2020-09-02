import Foundation
import RealmSwift

@objcMembers final class ForecastDate: Object {
  dynamic var date = Date()
  private let formatter = DateFormatter()

  private enum CodingKeys: String, CodingKey {
    case time
  }
  
  var textualRepresentation: String {
    return "\(self.longDayMonth), \(self.weekday) \(self.time)"
  }
  
  convenience init(timeInterval: TimeInterval) {
    self.init()
    date = Date(timeIntervalSince1970: timeInterval)
  }
  
  required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let timeInterval = try container.decode(Int.self, forKey: .time)
    
    self.init(timeInterval: TimeInterval(timeInterval))
  }
  
  required init() {
    super.init()
  }
}

// MARK: - Various date formats
extension ForecastDate {
  
  var time: String {
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    let time = formatter.string(from: date)
    return time
  }
  
  var longDayMonth: String { // June 1
    formatter.dateFormat = "MMMM d"
    let date = formatter.string(from: self.date)
    return date
  }
  
  var mediumDayMonth: String {
    formatter.dateFormat = "dd MMM"
    let date = formatter.string(from: self.date)
    return date
  }
  
  var weekday: String {
    formatter.dateFormat = "EEEE"
    let weekday = formatter.string(from: date)
    return weekday
  }
  
}
