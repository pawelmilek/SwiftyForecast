import Foundation
import CoreLocation

final class DefaultCurrentForecastViewModel: CurrentForecastViewModel {
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
    return city?.location
  }
  
  let userInfoSegmentedControlChangeKey = "SegmentedControlChange"
  
  var onSuccess: (() -> Void)?
  var onFailure: ((Error) -> Void)?
  var onLoadingStatus: ((Bool) -> Void)?
  var pageIndex = 0
  
  private var city: City?
  private var isCurrentLocationPage: Bool {
    return pageIndex == 0
  }
  
  private var isLoadingData = false {
    didSet {
      onLoadingStatus?(isLoadingData)
    }
  }

  private let service: ForecastService
  private var weatherForecast: WeatherForecast?
  
  init(service: ForecastService) {
    self.service = service
  }
  
  func city(at index: Int) -> City? {
    return nil
  }
  
  func loadData() {
    if isCurrentLocationPage && LocationProvider.shared.isLocationServicesEnabled {
      fetchCurrentLocationForecast()
      
    } else if let city = city {
      // TODO:
    }
  }
  
  func fetchCurrentLocationForecast() {
    GeocoderHelper.currentLocation { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let placemark):
        let currentCity = try? City.add(from: placemark)
        self.city = currentCity
        self.fetchForecast()
        
      case .failure(let error):
        self.onFailure?(error)
      }
    }
  }
}

// MARK: - Private - Fetch Forecast Data
private extension DefaultCurrentForecastViewModel {
  
  func fetchForecast() {
    guard !isLoadingData else { return }
    guard let location = location else { return }
    
    isLoadingData = true
    service.getForecast(by: location) { [weak self] response in
      guard let self = self else { return }
      guard let city = self.city else { return }
      
      switch response {
      case .success(let data):
        self.weatherForecast = WeatherForecast(city: city, forecastResponse: data)
        self.onSuccess?()
        
      case .failure(let error):
        self.weatherForecast = nil
        self.onFailure?(error)
      }
      
      self.isLoadingData = false
    }
  }
  
}
