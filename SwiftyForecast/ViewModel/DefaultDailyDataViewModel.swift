import Foundation

struct DefaultDailyDataViewModel: DailyDataViewModel {
  typealias DailyStyle = Style.DailyForecastCell
  
  var attributedDate: NSAttributedString
  var conditionIcon: NSAttributedString?
  var temperatureMax: String
  
  init(dailyData: DailyData) {
    let weekday = dailyData.date.weekday.uppercased()
    let month = dailyData.date.longDayMonth.uppercased()
    
    let fullDate = ("\(weekday)\r\n\(month)") as NSString
    let weekdayRange = fullDate.range(of: weekday)
    let monthRange = fullDate.range(of: month)
    
    let attributedString = NSMutableAttributedString(string: fullDate as String)
    attributedString.addAttributes([.font: DailyStyle.weekdayLabelFont], range: weekdayRange)
    attributedString.addAttributes([.font: DailyStyle.monthLabelFont], range: monthRange)
    
    attributedDate = attributedString
    conditionIcon = ConditionFontIcon.make(icon: dailyData.icon,
                                           font: DailyStyle.conditionIconSize)?.attributedIcon
    temperatureMax = dailyData.temperatureMaxFormatted
  }
}
