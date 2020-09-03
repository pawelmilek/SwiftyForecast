import Foundation

protocol HourlyForecastCellViewModel {
  var time: String { get }
  var conditionIcon: NSAttributedString? { get }
  var temperature: String { get }
  
  init(hourlyData: HourlyDataDTO)
}
