import Foundation

struct DailyDateRenderer {
  
  static func render(weekday: String, month: String) -> NSAttributedString {
    let fullDate = ("\(weekday)\r\n\(month)") as NSString
    let weekdayRange = fullDate.range(of: weekday)
    let monthRange = fullDate.range(of: month)
    
    let attributedString = NSMutableAttributedString(string: fullDate as String)
    attributedString.addAttributes([.font: Style.DailyForecastCell.weekdayLabelFont],
                                   range: weekdayRange)
    attributedString.addAttributes([.font: Style.DailyForecastCell.monthLabelFont],
                                   range: monthRange)
    return attributedString
  }
  
  static func render(_ date: ForecastDate) -> NSAttributedString {
    let weekday = date.weekday.uppercased()
    let month = date.longDayMonth.uppercased()
    let fullDate = ("\(weekday)\r\n\(month)") as NSString
    let weekdayRange = fullDate.range(of: weekday)
    let monthRange = fullDate.range(of: month)
    
    let attributedString = NSMutableAttributedString(string: fullDate as String)
    attributedString.addAttributes([.font: Style.DailyForecastCell.weekdayLabelFont],
                                   range: weekdayRange)
    attributedString.addAttributes([.font: Style.DailyForecastCell.monthLabelFont],
                                   range: monthRange)
    return attributedString
  }
  
}

