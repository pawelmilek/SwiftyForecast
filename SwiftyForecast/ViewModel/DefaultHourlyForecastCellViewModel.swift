import Foundation

struct DefaultHourlyForecastCellViewModel: HourlyForecastCellViewModel {
  var time: String
  var conditionIcon: NSAttributedString?
  private var hourlyData: HourlyData
  
  init(hourlyData: HourlyData) {
    self.hourlyData = hourlyData
    self.time = hourlyData.date.time
    
    let iconSize = Style.HourlyForecastCell.conditionIconSize
    self.conditionIcon = ConditionFontIcon.make(icon: hourlyData.icon, font: iconSize)?.attributedIcon
  }
}

// MARK: - Temperature in Celsius
extension DefaultHourlyForecastCellViewModel {
  
  var temperature: String {
    switch MeasuringSystem.selected {
    case .metric:
      let temperatureInCelsius = (hourlyData.temperature - 32) * Double(5.0 / 9.0)
      return temperatureInCelsius.roundedToString + Style.degreeSign
      
    case .imperial:
      return hourlyData.temperature.roundedToString + Style.degreeSign
    }
  }
  
}
