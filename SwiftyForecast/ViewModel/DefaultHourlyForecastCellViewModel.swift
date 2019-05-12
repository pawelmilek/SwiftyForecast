import Foundation

struct DefaultHourlyForecastCellViewModel: HourlyForecastCellViewModel {
  var time: String
  var conditionIcon: NSAttributedString?
  private var hourlyData: HourlyData
  
  init(hourlyData: HourlyData) {
    self.hourlyData = hourlyData
    time = hourlyData.date.time
    conditionIcon = ConditionFontIcon.make(icon: hourlyData.icon, font: 25)?.attributedIcon
  }
}

// MARK: - Temperature in Celsius
extension DefaultHourlyForecastCellViewModel {
  
  var temperature: String {
    if MeasuringSystem.selected == .metric {
      let temperatureInCelsius = (hourlyData.temperature - 32) * Double(5.0 / 9.0)
      return temperatureInCelsius.roundedToString + "\u{00B0}"
    } else {
      return hourlyData.temperature.roundedToString + "\u{00B0}"
    }
  }
  
}
