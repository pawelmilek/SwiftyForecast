import Foundation

struct RateLimiter {
  private static let limitIntervalInMinutes = 10
  
  static func shouldFetch(by date: Date) -> Bool { // TODO: or if location changed!!
    let nowString = Date().toString()
    let nowFormatted = nowString.toDate() ?? Date()
    
    let dateString = date.toString()
    let dateFormatted = dateString.toDate() ?? Date()
    
    let numberOfMinutes = Date.minutesBetweenDates(from: dateFormatted, to: nowFormatted) ?? 0
    return numberOfMinutes >= limitIntervalInMinutes
  }
}
