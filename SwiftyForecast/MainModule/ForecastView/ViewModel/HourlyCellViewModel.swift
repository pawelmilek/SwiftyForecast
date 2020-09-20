import Foundation

protocol HourlyCellViewModel {
  var time: String { get }
  var conditionIcon: NSAttributedString? { get }
  var temperature: String { get }
  
  init(hourlyData: HourlyDataDTO)
}
