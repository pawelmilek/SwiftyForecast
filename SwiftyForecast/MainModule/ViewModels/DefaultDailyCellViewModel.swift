import Foundation

struct DefaultDailyCellViewModel: DailyCellViewModel {
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
  
  private let dailyData: DailyDataDTO
  
  init(dailyData: DailyDataDTO) {
    self.dailyData = dailyData
    attributedDate = DailyDateRenderer.render(dailyData.date)
    conditionIcon = ConditionFontIcon.make(icon: dailyData.icon,
                                           font: Style.DailyForecastCell.conditionIconSize)?.attributedIcon
  }
}
