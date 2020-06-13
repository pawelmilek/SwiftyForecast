import Foundation
import CoreLocation

final class DefaultContentViewModel: ContentViewModel {
  var hourly: HourlyForecast? {
    return weatherForecast?.hourly
  }
  
  var icon: NSAttributedString? {
    guard let current = weatherForecast?.currently else { return nil }
    let font = Style.CurrentForecast.conditionFontIconSize
    let attributedIcon = ConditionFontIcon.make(icon: current.icon, font: font)?.attributedIcon
    return attributedIcon
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
  
  var location: CLLocation? {
    return city.location
  }
  
  var onSuccess: (() -> Void)?
  var onFailure: ((Error) -> Void)?
  var onLoadingStatus: ((Bool) -> Void)?
  var pageIndex = 0
  
  
  private var isCurrentLocationPage: Bool {
    return pageIndex == 0
  }
  
  private var isLoadingData = false {
    didSet {
      onLoadingStatus?(isLoadingData)
    }
  }

  private let city: City
  private let service: ForecastService
  private var weatherForecast: WeatherForecast?
  
  init(city: City, service: ForecastService) {
    self.city = city
    self.service = service
  }
}

// MARK: - Private - Fetch Forecast Data
extension DefaultContentViewModel {
  
  func loadData() {
    guard !isLoadingData else { return }
    guard let location = location else { return }
    
    isLoadingData = true
    service.getForecast(by: location) { [weak self] response in
      guard let self = self else { return }
      
      switch response {
      case .success(let data):
        self.weatherForecast = WeatherForecast(city: self.city, forecastResponse: data)
        self.onSuccess?()
        
      case .failure(let error):
        self.weatherForecast = nil
        self.onFailure?(error)
      }
      
      self.isLoadingData = false
    }
  }
  
}
