import Foundation

struct DailyDateRenderer {
  
  static func render(_ date: Date) -> NSAttributedString {
    let formatter = DateFormatter()
    
    formatter.dateFormat = "MMMM d"
    let month = formatter.string(from: date).uppercased()
    
    formatter.dateFormat = "EEEE"
    let weekday = formatter.string(from: date).uppercased()

    let fullDate = ("\(weekday)\r\n\(month)") as NSString
    let weekdayRange = fullDate.range(of: weekday)
    let monthRange = fullDate.range(of: month)
    
    let attributedString = NSMutableAttributedString(string: fullDate as String)
    attributedString.addAttributes([.font: Style.DailyForecastCell.weekdayLabelFont], range: weekdayRange)
    attributedString.addAttributes([.font: Style.DailyForecastCell.monthLabelFont], range: monthRange)
    return attributedString
  }
  
}

