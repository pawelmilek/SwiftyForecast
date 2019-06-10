import Foundation

struct DefaultHourlyForecastCellViewModel: HourlyForecastCellViewModel {
  let time: String
  let conditionIcon: NSAttributedString?
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
//    let hourlyTemperature = hourlyData.temperature
//    
//    switch ForecastUserDefaults.unitsNotation() {
//    case .imperial:
//      return hourlyTemperature.roundedToString + Style.degreeSign
//      
//    case .metric:
//      let temperatureInCelsius = hourlyTemperature.ToCelsius()
//      return temperatureInCelsius.roundedToString + Style.degreeSign
//    }
    
    switch MeasuringSystem.selected {
    case .metric:
      let temperatureInCelsius = hourlyData.temperature.ToCelsius()
      return temperatureInCelsius.roundedToString + Style.degreeSign
      
    case .imperial:
      return hourlyData.temperature.roundedToString + Style.degreeSign
    }
  }
  
}
