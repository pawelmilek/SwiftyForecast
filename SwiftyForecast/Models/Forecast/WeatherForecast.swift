struct WeatherForecast {
  let city: City
  let currently: CurrentForecast
  let hourly: HourlyForecast
  let daily: DailyForecast
  
  init(city: City, forecastResponse: ForecastResponse) {
    self.city = city
    self.currently = forecastResponse.currently
    self.hourly = forecastResponse.hourly
    self.daily = forecastResponse.daily
  }
}
