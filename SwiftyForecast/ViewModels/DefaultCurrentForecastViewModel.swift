import Foundation

protocol CurrentForecastViewModelDelegate: class {
  func currentForecastViewModelDidFetchData(_ viewModel: CurrentForecastViewModel,
                                            error: WebServiceError?)
}

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
  
//  var sunriseIcon: NSAttributedString
//  var sunsetIcon: NSAttributedString
  var sunriseTime: String {
    guard let details = weatherForecast?.daily.currentDayData else { return "" }
    return city.timeZone != nil ? details.sunriseTime.time(by: city.timeZone) : details.sunriseTime.time
  }
  
  var sunsetTime: String {
    guard let details = weatherForecast?.daily.currentDayData else { return "" }
    return city.timeZone != nil ? details.sunsetTime.time(by: city.timeZone) : details.sunsetTime.time
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
  private let city: City
  private let coordinate: Coordinate
  private let service: ForecastService
  private var weatherForecast: WeatherForecast?
  
  init(city: City, service: ForecastService, delegate: CurrentForecastViewModelDelegate?) {
    self.city = city
    self.service = service
    self.delegate = delegate
    self.coordinate = Coordinate(latitude: city.latitude, longitude: city.longitude)
    fetchForecast()
  }
}

// MARK: - Private - Fetch Forecast Data
private extension DefaultCurrentForecastViewModel {
  
  func fetchForecast() {
    service.getForecast(by: coordinate) { response in
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
  
  func fetchForecast(for city: City) {
    
  }
  
}
