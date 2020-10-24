import Foundation
import CoreLocation

protocol ContentViewModel: class {
  var hourly: HourlyForecastDTO? { get }
  var icon: NSAttributedString? { get }
  var weekdayMonthDay: String { get }
  var cityName: String { get }
  var temperature: String { get }
  var windSpeed: String { get }
  var humidity: String { get }
  var sunriseTime: String { get }
  var sunsetTime: String { get }
  var numberOfDays: Int { get }
  var sevenDaysData: [DailyDataDTO] { get }
  var location: LocationDTO { get }
  var pageIndex: Int { get set }
  
  var onSuccess: (() -> Void)? { get set }
  var onFailure: ((Error) -> Void)? { get set }
  var onLoadingStatus: ((Bool) -> Void)? { get set }
  
  init(city: CityDTO, repository: Repository)

  func loadData()
}
