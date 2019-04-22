import Foundation

protocol HourlyDataViewModel {
  var time: String { get }
  var conditionIcon: NSAttributedString? { get }
  var temperature: String { get }
  
  init(hourlyData: HourlyData)
}
