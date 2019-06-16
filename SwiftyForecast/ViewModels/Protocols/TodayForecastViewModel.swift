import Foundation

protocol TodayForecastViewModel {
  var icon: NSAttributedString? { get }
  var humidity: String { get }
  var summary: String { get }
  var temperatureMinMax: String { get }
  
  init(dailyData: DailyData)
}
