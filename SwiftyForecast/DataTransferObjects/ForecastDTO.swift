struct ForecastDTO {
  let timezone: String
  let location: LocationDTO
  let currently: CurrentForecastDTO
  let hourly: HourlyForecastDTO
  let daily: DailyForecastDTO
}
