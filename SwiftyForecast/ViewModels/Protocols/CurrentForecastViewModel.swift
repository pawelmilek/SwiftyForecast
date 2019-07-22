import Foundation

protocol CurrentForecastViewModel {
  //  var city: City? { get } TODO: Modify City class by removing it from CoreData
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
  var numberOfDays: Int { get }
  var sevenDaysData: [DailyData] { get }
}
