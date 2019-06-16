import Foundation

struct DefaultDailyForecastCellViewModel: DailyForecastCellViewModel {
  let attributedDate: NSAttributedString
  let conditionIcon: NSAttributedString?
  var temperatureMin: String {
    if NotationSystem.selectedUnitNotation == .metric {
      let temperatureInCelsiusMin = dailyData.temperatureMin.ToCelsius()
      return temperatureInCelsiusMin.roundedToString + Style.degreeSign
    } else {
      return dailyData.temperatureMin.roundedToString + Style.degreeSign
    }
  }
  
  var temperatureMax: String {
    if NotationSystem.selectedUnitNotation == .metric {
      let temperatureInCelsiusMax = dailyData.temperatureMax.ToCelsius()
      return temperatureInCelsiusMax.roundedToString + Style.degreeSign
    } else {
      return dailyData.temperatureMax.roundedToString + Style.degreeSign
    }
  }
  
  private let dailyData: DailyData
  
  init(dailyData: DailyData) {
    self.dailyData = dailyData
    
    let weekday = self.dailyData.date.weekday.uppercased()
    let month = self.dailyData.date.longDayMonth.uppercased()
    
    attributedDate = DailyDateRenderer.render(weekday: weekday, month: month)
    conditionIcon = ConditionFontIcon.make(icon: dailyData.icon,
                                           font: Style.DailyForecastCell.conditionIconSize)?.attributedIcon
  }
}
