struct WeatherForecast {
  let city: CityRealm
  let currently: CurrentForecast
  let hourly: HourlyForecast
  let daily: DailyForecast
}

extension WeatherForecast {
  
  init(city: CityRealm, forecastResponse: ForecastResponse) {
    self.city = city
    self.currently = forecastResponse.currently
    self.hourly = forecastResponse.hourly    
    self.daily = forecastResponse.daily
  }
  
}
