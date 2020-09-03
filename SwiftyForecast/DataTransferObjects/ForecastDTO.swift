import Foundation

struct ForecastDTO {
  let timezone: String
  let location: LocationDTO
  let currently: CurrentForecastDTO
  let hourly: HourlyForecastDTO
  let daily: DailyForecastDTO
}

struct CurrentForecastDTO {
  let date: ForecastDateDTO
  let temperatureFormatted: String
  let summary: String
  let icon: String
  let humidity: Double
  let pressure: Double
  let windSpeed: Double
}

struct HourlyForecastDTO {
  let summary: String
  let icon: String
  let data: [HourlyDataDTO]
}

struct HourlyDataDTO {
  let date: ForecastDateDTO
  let summary: String
  let icon: String
  let temperature: Double
}

struct DailyDataDTO {
  let date: ForecastDateDTO
  let summary: String
  let icon: String
  let sunriseTime: ForecastDateDTO
  let sunsetTime: ForecastDateDTO
  let temperatureMin: Double
  let temperatureMax: Double
}

struct DailyForecastDTO {
  let summary: String
  let icon: String
  let numberOfDays: Int
  let currentDayData: DailyDataDTO
  let sevenDaysData: [DailyDataDTO]
  
}

struct ForecastDateDTO {
  let longDayMonth: String
  let mediumDayMonth: String
  let weekday: String
  let time: String
  let textualRepresentation: String
}

struct CityDTO {
  let id: Int
  let name: String
  let country: String
  let timeZoneName: String
  let isUserLocation = false
  let location: LocationDTO
}

struct LocationDTO {
  let latitude: Double
  let longitude: Double
}


