import Foundation

protocol DailyForecastCellViewModel {
  var attributedDate: NSAttributedString { get }
  var conditionIcon: NSAttributedString? { get }
  var temperatureMin: String { get }
  var temperatureMax: String { get }
  
  init(dailyData: DailyData)
}
