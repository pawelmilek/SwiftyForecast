import Foundation
import CoreLocation
import RealmSwift

final class DefaultContentViewModel: ContentViewModel {
  var hourly: HourlyForecastDTO? {
    return forecast?.hourly
  }
  
  var icon: NSAttributedString? {
    guard let icon = forecast?.currently.icon else { return nil }
    let font = Style.CurrentForecast.conditionFontIconSize
    let attributedIcon = ConditionFontIcon.make(icon: icon, font: font)?.attributedIcon
    return attributedIcon
  }
  
  var weekdayMonthDay: String {
    guard let date = forecast?.currently.date else { return InvalidReference.notApplicable }
    return "\(date.weekday), \(date.longDayMonth)".uppercased()
  }
  
  var cityName: String {
    return city?.name ?? InvalidReference.notApplicable
  }
  
  var temperature: String {
    guard let currently = forecast?.currently else { return InvalidReference.notApplicable }
    switch ForecastUserDefaults.unitNotation {
    case .imperial:
      return currently.temperature.roundedToString + Style.degreeSign
      
    case .metric:
      let temperatureInCelsius = currently.temperature.ToCelsius()
      return temperatureInCelsius.roundedToString + Style.degreeSign
    }
  }
  
  var humidity: String {
    guard let current = forecast?.currently else { return InvalidReference.notApplicable }
    return "\(Int(current.humidity * 100))"
  }
  
  var sunriseTime: String {
    guard let sunriseTime = forecast?.daily.currentDayData.sunriseTime else { return InvalidReference.notApplicable }
    return sunriseTime.time
  }
  
  var sunsetTime: String {
    guard let sunsetTime = forecast?.daily.currentDayData.sunsetTime else { return InvalidReference.notApplicable }
    return sunsetTime.time
  }
  
  var windSpeed: String {
    let speed = forecast?.currently.windSpeed ?? 0
    switch ForecastUserDefaults.unitNotation {
    case .imperial:
      return String(format: "%.f MPH", speed)
      
    case .metric:
      return String(format: "%.f KPH", speed.toKPH())
    }
  }
  
  var numberOfDays: Int {
    return forecast?.daily.numberOfDays ?? 0
  }
  
  var sevenDaysData: [DailyDataDTO] {
    return forecast?.daily.sevenDaysData ?? []
  }
  
  var location: LocationDTO? {
    return city?.location
  }
  
  var onSuccess: (() -> Void)?
  var onFailure: ((Error) -> Void)?
  var onLoadingStatus: ((Bool) -> Void)?
  var pageIndex = 0
  
  private var isLoadingData = false {
    didSet {
      onLoadingStatus?(isLoadingData)
    }
  }
  
  private let city: CityDTO?
  private let repository: Repository
  private var forecast: ForecastDTO?
  
  init(city: City, repository: Repository) {
    self.city = ModelTranslator().translate(city)
    self.repository = repository
  }
}

// MARK: - Private - Fetch Forecast Data
extension DefaultContentViewModel {
  
  func loadData() {
    guard !isLoadingData else { return }
    guard let location = location else { return }
    
    isLoadingData = true
    repository.getForecast(latitude: location.latitude, longitude: location.latitude) { [weak self] response in
      guard let self = self else { return }
      
      switch response {
      case .success(let data):
        self.forecast = data
        self.onSuccess?()
        
      case .failure(let error):
        self.forecast = nil
        self.onFailure?(error)
      }
      
      self.isLoadingData = false
    }
  }
  
}
