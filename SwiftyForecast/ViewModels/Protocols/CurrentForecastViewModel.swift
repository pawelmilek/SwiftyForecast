import Foundation

protocol CurrentForecastViewModel {
  var city: CityRealm { get }
  var hourly: HourlyForecast? { get }
  var icon: NSAttributedString? { get }
  var weekdayMonthDay: String { get }
  var cityName: String { get }
  var temperature: String { get }
  var windSpeed: String { get }
  var humidity: String { get }
  var sunriseTime: String { get }
  var sunsetTime: String { get }
  var numberOfDays: Int { get }
  var sevenDaysData: [DailyData] { get }

  init(city: CityRealm, service: ForecastService, delegate: CurrentForecastViewModelDelegate?)
}
