import Foundation

struct DefaultDailyCellViewModel: DailyCellViewModel {
  let attributedDate: NSAttributedString
  let conditionIcon: NSAttributedString?
  var temperatureMin: String {
    switch notationController.temperatureNotation {
    case .celsius:
      let temperatureInCelsiusMin = dailyData.temperatureMin.ToCelsius()
      return temperatureInCelsiusMin.roundedToString + Style.degreeSign
      
    case .fahrenheit:
      return dailyData.temperatureMin.roundedToString + Style.degreeSign
    }
  }
  
  var temperatureMax: String {
    switch notationController.temperatureNotation {
    case .celsius:
      let temperatureInCelsiusMax = dailyData.temperatureMax.ToCelsius()
      return temperatureInCelsiusMax.roundedToString + Style.degreeSign
      
    case .fahrenheit:
      return dailyData.temperatureMax.roundedToString + Style.degreeSign
    }
  }
  
  private let dailyData: DailyDataDTO
  private let notationController: NotationController

  init(dailyData: DailyDataDTO, notationController: NotationController = NotationController()) {
    self.dailyData = dailyData
    self.notationController = notationController
    self.attributedDate = DailyDateRenderer.render(dailyData.date)
    self.conditionIcon = ConditionFontIcon.make(icon: dailyData.icon,
                                                font: Style.DailyForecastCell.conditionIconSize)?.attributedIcon
  }
}
