import Foundation

protocol DailyForecastCellViewModel {
  var attributedDate: NSAttributedString { get }
  var conditionIcon: NSAttributedString? { get }
  var temperatureMax: String { get }
  
  init(dailyData: DailyData)
}
