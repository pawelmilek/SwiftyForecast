struct DailyForecastDTO {
  let summary: String
  let icon: String
  let numberOfDays: Int
  let currentDayData: DailyDataDTO
  let sevenDaysData: [DailyDataDTO]
}
