struct WeatherModel {
    let timezone: Int
    let latitude: Double
    let longitude: Double
    let current: CurrentWeatherModel
    let hourly: [HourlyForecastModel]
    let daily: [DailyForecastModel]
}
