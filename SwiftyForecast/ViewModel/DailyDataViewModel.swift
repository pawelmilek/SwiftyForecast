import Foundation

protocol DailyDataViewModel {
  var attributedDate: NSAttributedString { get }
  var conditionIcon: NSAttributedString? { get }
  var temperatureMax: String { get }
  
  init(dailyData: DailyData)
}
