import Foundation

protocol CurrentForecastViewModel {
  var hourly: HourlyForecast? { get }
  var icon: NSAttributedString? { get }
  var weekdayMonthDay: String { get }
  var cityName: String { get }
  var temperature: String { get }
  var windSpeed: String { get }
  var humidity: String { get }
//  var sunriseIcon: NSAttributedString { get }
//  var sunsetIcon: NSAttributedString { get }
  var sunriseTime: String { get }
  var sunsetTime: String { get }
}
