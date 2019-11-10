import Foundation
import CoreLocation

final class DefaultCurrentForecastViewModel: CurrentForecastViewModel {
  var hourly: HourlyForecast? {
    return weatherForecast?.hourly
  }
  
  var icon: NSAttributedString? {
    guard let current = weatherForecast?.currently else { return nil }
    return ConditionFontIcon.make(icon: current.icon, font: Style.CurrentForecast.conditionFontIconSize)?.attributedIcon
  }
  
  var weekdayMonthDay: String {
    guard let current = weatherForecast?.currently else { return "" }
    return "\(current.date.weekday), \(current.date.longDayMonth)".uppercased()
  }
  
  var cityName: String {
    return weatherForecast?.city.name ?? ""
  }
  
  var temperature: String {
    return weatherForecast?.currently.temperatureFormatted ?? ""
  }
  
  var humidity: String {
    guard let current = weatherForecast?.currently else { return "" }
    return "\(Int(current.humidity * 100))"
  }

  var sunriseTime: String {
    guard let details = weatherForecast?.daily.currentDayData else { return "" }
    return details.sunriseTime.time
  }
  
  var sunsetTime: String {
    guard let details = weatherForecast?.daily.currentDayData else { return "" }
    return details.sunsetTime.time
  }
  
  var windSpeed: String {
    let speed = weatherForecast?.currently.windSpeed ?? 0
    switch ForecastUserDefaults.unitNotation {
    case .imperial:
      return String(format: "%.f MPH", speed)
      
    case .metric:
      return String(format: "%.f KPH", speed.toKPH())
    }
  }
  
  var numberOfDays: Int {
    return weatherForecast?.daily.numberOfDays ?? 0
  }
  
  var sevenDaysData: [DailyData] {
    return weatherForecast?.daily.sevenDaysData ?? []
  }
  
  weak var delegate: CurrentForecastViewModelDelegate?
  let city: CityRealm
  private let location: CLLocation
  private let service: ForecastService
  private var weatherForecast: WeatherForecast?
  
  init(city: CityRealm, service: ForecastService, delegate: CurrentForecastViewModelDelegate?) {
    self.city = city
    self.service = service
    self.delegate = delegate
    self.location = city.location!
    fetchForecast()
  }
}

// MARK: - Private - Fetch Forecast Data
private extension DefaultCurrentForecastViewModel {
  
  func fetchForecast() {
    service.getForecast(by: location) { [weak self] response in
      guard let self = self else { return }
      
      switch response {
      case .success(let data):
        self.weatherForecast = WeatherForecast(city: self.city, forecastResponse: data)
        self.delegate?.currentForecastViewModelDidFetchData(self, error: nil)

      case .failure(let error):
        self.weatherForecast = nil
        self.delegate?.currentForecastViewModelDidFetchData(self, error: error)
      }
    }
  }
  
}
