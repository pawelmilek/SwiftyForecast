struct ForecastDTO {
  let timezone: String
  let latitude: Double
  let longitude: Double
  let currently: CurrentForecastDTO
  let hourly: HourlyForecastDTO
  let daily: DailyForecastDTO
}
