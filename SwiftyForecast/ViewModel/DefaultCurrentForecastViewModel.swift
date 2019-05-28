import Foundation

struct DefaultCurrentForecastViewModel: CurrentForecastViewModel {
  var hourly: HourlyForecast?
  var icon: NSAttributedString?
  var weekdayMonthDay: String
  var cityName: String
  var temperature: String
  var windSpeed: String
  var humidity: String
//  var sunriseIcon: NSAttributedString
//  var sunsetIcon: NSAttributedString
  var sunriseTime: String
  var sunsetTime: String
  
  init(weatherForecast: WeatherForecast) {
    let city = weatherForecast.city
    let current = weatherForecast.currently
    let details = weatherForecast.daily.currentDayData!
    
    hourly = weatherForecast.hourly
    icon = ConditionFontIcon.make(icon: current.icon, font: Style.CurrentForecast.conditionFontIconSize)?.attributedIcon
    weekdayMonthDay = "\(current.date.weekday), \(current.date.longDayMonth)".uppercased()
    cityName = city.name
    temperature = current.temperatureFormatted
    windSpeed = "\(current.windSpeed)"
    humidity = "\(Int(current.humidity * 100))"
  
    sunriseTime = city.timeZone != nil ? details.sunriseTime.time(by: city.timeZone) : details.sunriseTime.time
    sunsetTime = city.timeZone != nil ? details.sunsetTime.time(by: city.timeZone) : details.sunsetTime.time
  }
}
