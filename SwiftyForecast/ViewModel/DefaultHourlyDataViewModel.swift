import Foundation

struct DefaultHourlyDataViewModel: HourlyDataViewModel {
  var time: String
  var conditionIcon: NSAttributedString?
  private let hourlyData: HourlyData
  
  init(hourlyData: HourlyData) {
    self.hourlyData = hourlyData
    time = hourlyData.date.time
    conditionIcon = ConditionFontIcon.make(icon: hourlyData.icon, font: 25)?.attributedIcon
  }
}

// MARK: - Temperature in Celsius
extension DefaultHourlyDataViewModel {
  
  var temperature: String {
    if MeasuringSystem.selected == .metric {
      let temperatureInCelsius = (hourlyData.temperature - 32) * Double(5.0 / 9.0)
      return temperatureInCelsius.roundedToNearestAsString + "\u{00B0}"
    } else {
      return hourlyData.temperature.roundedToNearestAsString + "\u{00B0}"
    }
  }
  
}
