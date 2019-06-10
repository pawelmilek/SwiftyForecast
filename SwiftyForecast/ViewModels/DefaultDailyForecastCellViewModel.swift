import Foundation

struct DefaultDailyForecastCellViewModel: DailyForecastCellViewModel {
  let attributedDate: NSAttributedString
  let conditionIcon: NSAttributedString?
  let temperatureMax: String
  
  init(dailyData: DailyData) {
    let weekday = dailyData.date.weekday.uppercased()
    let month = dailyData.date.longDayMonth.uppercased()

    attributedDate = DailyDateRenderer.render(weekday: weekday, month: month)
    conditionIcon = ConditionFontIcon.make(icon: dailyData.icon,
                                           font: Style.DailyForecastCell.conditionIconSize)?.attributedIcon
    temperatureMax = dailyData.temperatureMaxFormatted
  }
}
