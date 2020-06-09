import Foundation
import CoreLocation

protocol CurrentForecastViewModel {
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
  var location: CLLocation? { get }
  var userInfoSegmentedControlChangeKey: String { get }
  var pageIndex: Int { get set }
  
  var onSuccess: (() -> Void)? { get set }
  var onFailure: ((Error) -> Void)? { get set }
  var onLoadingStatus: ((Bool) -> Void)? { get set }
  
  init(service: ForecastService)

  func city(at index: Int) -> City?
  func loadData()
  func fetchCurrentLocationForecast()
}
