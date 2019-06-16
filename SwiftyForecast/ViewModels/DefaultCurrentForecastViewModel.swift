import Foundation

struct DefaultCurrentForecastViewModel: CurrentForecastViewModel {
  let hourly: HourlyForecast?
  let icon: NSAttributedString?
  let weekdayMonthDay: String
  let cityName: String
  let temperature: String
  let humidity: String
//  var sunriseIcon: NSAttributedString
//  var sunsetIcon: NSAttributedString
  let sunriseTime: String
  let sunsetTime: String
  var windSpeed: String {
    let speed = weatherForecast.currently.windSpeed
    
    switch UserDefaultsAdapter.unitNotation {
    case .imperial:
      return String(format: "%.f MPH", speed)
      
    case .metric:
      return String(format: "%.f KPH", speed.toKPH())
    }
  }
  
  private let weatherForecast: WeatherForecast
  
  init(weatherForecast: WeatherForecast) {
    self.weatherForecast = weatherForecast
    
    let city = weatherForecast.city
    let current = weatherForecast.currently
    let details = weatherForecast.daily.currentDayData!
    
    hourly = weatherForecast.hourly
    icon = ConditionFontIcon.make(icon: current.icon, font: Style.CurrentForecast.conditionFontIconSize)?.attributedIcon
    weekdayMonthDay = "\(current.date.weekday), \(current.date.longDayMonth)".uppercased()
    cityName = city.name
    temperature = current.temperatureFormatted
    humidity = "\(Int(current.humidity * 100))"
    sunriseTime = city.timeZone != nil ? details.sunriseTime.time(by: city.timeZone) : details.sunriseTime.time
    sunsetTime = city.timeZone != nil ? details.sunsetTime.time(by: city.timeZone) : details.sunsetTime.time
  }
}
