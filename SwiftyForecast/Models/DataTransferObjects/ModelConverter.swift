import Foundation
import RealmSwift
import CoreLocation

struct ModelTranslator {

  func translate(_ city: City?) -> CityDTO? {
    guard let city = city else { return nil }
    guard let location = translate(city.location) else { return nil }

    let cityDTO = CityDTO(id: city.id,
                          name: city.name,
                          country: city.country,
                          timeZoneName: city.timeZoneName,
                          location: location)
    return cityDTO
  }

  func translate(_ city: City, _ forecast: ForecastResponse?) -> ForecastDTO? {
    guard let forecast = forecast else { return nil }
    guard let cityDTO = translate(city) else { return nil }
    guard let location = translate(forecast.location) else { return nil }
    guard let currently = translate(forecast.currently) else { return nil }
    guard let hourly = translate(forecast.hourly) else { return nil }
    guard let daily = translate(forecast.daily) else { return nil }

    let forecastDTO = ForecastDTO(city: cityDTO,
                                  timezone: forecast.timezone,
                                  location: location,
                                  currently: currently,
                                  hourly: hourly,
                                  daily: daily)
    return forecastDTO
  }

  func translate(_ currentForecast: CurrentForecast?) -> CurrentForecastDTO? {
    guard let currentForecast = currentForecast else { return nil }
    guard let date = translate(currentForecast.date) else { return nil }

    let currentForecastDTO = CurrentForecastDTO(date: date,
                                                temperatureFormatted: currentForecast.temperatureFormatted,
                                                summary: currentForecast.summary,
                                                icon: currentForecast.icon,
                                                humidity: currentForecast.humidity,
                                                pressure: currentForecast.pressure,
                                                windSpeed: currentForecast.windSpeed)
    return currentForecastDTO
  }

  func translate(_ hourlyForecast: HourlyForecast?) -> HourlyForecastDTO? {
    guard let hourlyForecast = hourlyForecast else { return nil }

    return nil
  }

  func translate(_ hourlyData: HourlyData?) -> HourlyDataDTO? {
    guard let hourlyData = hourlyData else { return nil }

    return nil
  }

  func translate(_ dailyData: DailyData?) -> DailyDataDTO? {
    guard let dailyData = dailyData else { return nil }

    return nil
  }

  func translate(_ dailyForecast: DailyForecast?) -> DailyForecastDTO? {
    guard let dailyForecast = dailyForecast else { return nil }

    return nil
  }

  func translate(_ forecastDate: ForecastDate?) -> ForecastDateDTO? {
    guard let forecastDate = forecastDate else { return nil }

    return nil
  }

  func translate(_ location: CLLocation?) -> LocationDTO? {
    guard let location = location else { return nil }

    return nil
  }

//  func translate(dto: ForecastDTO?, realm: Realm? = RealmProvider.core.realm) -> ForecastResponse? {
//    guard let dto = dto else { return nil }
//
//    return nil
//  }

}
