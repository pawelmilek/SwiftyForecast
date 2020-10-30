import Foundation

struct DefaultHourlyCellViewModel: HourlyCellViewModel {
  let time: String
  let conditionIcon: NSAttributedString?
  private var hourlyData: HourlyDataDTO
  
  init(hourlyData: HourlyDataDTO) {
    self.hourlyData = hourlyData
    self.time = hourlyData.date.getTime()
    
    let iconSize = Style.HourlyForecastCell.conditionIconSize
    self.conditionIcon = ConditionFontIcon.make(icon: hourlyData.icon, font: iconSize)?.attributedIcon
  }
}

// MARK: - Temperature in Celsius
extension DefaultHourlyCellViewModel {
  
  var temperature: String {
    
    switch NotationController().temperatureNotation {
    case .celsius:
      let temperatureInCelsius = hourlyData.temperature.ToCelsius()
      return temperatureInCelsius.roundedToString + Style.degreeSign
      
    case .fahrenheit:
      return hourlyData.temperature.roundedToString + Style.degreeSign
    }
  }
  
}
