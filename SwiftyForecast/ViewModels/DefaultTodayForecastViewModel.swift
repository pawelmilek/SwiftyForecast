import Foundation

struct DefaultTodayForecastViewModel: TodayForecastViewModel {
  let icon: NSAttributedString?
  let summary: String
  let humidity: String
  var temperatureMinMax: String {
    switch NotationSystem.selectedUnitNotation {
    case .imperial:
      let temperatureMin = dailyData.temperatureMin.roundedToString + Style.degreeSign
      let temperatureMax = dailyData.temperatureMax.roundedToString + Style.degreeSign
      return "\(temperatureMin) / \(temperatureMax)"
      
    case .metric:
      let temperatureMin = dailyData.temperatureMin.ToCelsius()
      let temperatureMax = dailyData.temperatureMax.ToCelsius()
      return "\(temperatureMin) / \(temperatureMax)"
    }
  }

  private let dailyData: DailyData
  
  init(dailyData: DailyData) {
    self.dailyData = dailyData
    icon = ConditionFontIcon.make(icon: dailyData.icon, font: Style.WeatherWidget.iconLabelFontSize)?.attributedIcon
    summary = dailyData.summary
    humidity = "Humidity: \(Int(dailyData.humidity * 100)) %"
  }
}
