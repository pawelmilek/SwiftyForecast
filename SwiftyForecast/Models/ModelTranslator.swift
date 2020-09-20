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
                          state: city.state,
                          postalCode: city.postalCode,
                          timeZoneName: city.timeZoneName,
                          lastUpdate: city.lastUpdate,
                          isUserLocation: city.isUserLocation,
                          location: location)
    return cityDTO
  }
  
  func translate(forecast: ForecastResponse?) -> ForecastDTO? {
    guard let forecast = forecast else { return nil }
    guard let location = translate(forecast.location) else { return nil }
    guard let currently = translate(forecast.currently) else { return nil }
    guard let hourly = translate(forecast.hourly) else { return nil }
    guard let daily = translate(forecast.daily) else { return nil }
    
    let forecastDTO = ForecastDTO(timezone: forecast.timezone,
                                  location: location,
                                  currently: currently,
                                  hourly: hourly,
                                  daily: daily)
    return forecastDTO
  }
  
  func translate(_ currentForecast: CurrentForecast?) -> CurrentForecastDTO? {
    guard let currentForecast = currentForecast else { return nil }
    
    let currentForecastDTO = CurrentForecastDTO(date: currentForecast.date,
                                                temperature: currentForecast.temperature,
                                                summary: currentForecast.summary,
                                                icon: currentForecast.icon,
                                                humidity: currentForecast.humidity,
                                                pressure: currentForecast.pressure,
                                                windSpeed: currentForecast.windSpeed)
    return currentForecastDTO
  }
  
  func translate(_ hourlyForecast: HourlyForecast?) -> HourlyForecastDTO? {
    guard let hourlyForecast = hourlyForecast else { return nil }
    
    let hourlyData = Array(hourlyForecast.data).compactMap({ self.translate($0) })
    let hourlyForecastDTO = HourlyForecastDTO(summary: hourlyForecast.summary, icon: hourlyForecast.icon, data: hourlyData)
    return hourlyForecastDTO
  }
  
  func translate(_ hourlyData: HourlyData?) -> HourlyDataDTO? {
    guard let hourlyData = hourlyData else { return nil }
    
    let hourlyDataDTO = HourlyDataDTO(date: hourlyData.date,
                                      summary: hourlyData.summary,
                                      icon: hourlyData.icon,
                                      temperature: hourlyData.temperature)
    return hourlyDataDTO
  }
  
  func translate(_ dailyData: DailyData?) -> DailyDataDTO? {
    guard let dailyData = dailyData else { return nil }
    
    let dailyDataDTO = DailyDataDTO(date: dailyData.date,
                                    summary: dailyData.summary,
                                    icon: dailyData.icon,
                                    sunriseTime: dailyData.sunriseTime,
                                    sunsetTime: dailyData.sunsetTime,
                                    temperatureMin: dailyData.temperatureMin,
                                    temperatureMax: dailyData.temperatureMax)
    return dailyDataDTO
  }
  
  func translate(_ dailyForecast: DailyForecast?) -> DailyForecastDTO? {
    guard let dailyForecast = dailyForecast else { return nil }
    guard let currentDayData = translate(dailyForecast.currentDayData) else { return nil }
    
    let sevenDaysData = Array(dailyForecast.sevenDaysData).compactMap({ self.translate($0) })
    let dailyForecastDTO = DailyForecastDTO(summary: dailyForecast.summary,
                                            icon: dailyForecast.icon,
                                            numberOfDays: dailyForecast.numberOfDays,
                                            currentDayData: currentDayData,
                                            sevenDaysData: sevenDaysData)
    return dailyForecastDTO
  }
  
  func translate(_ location: CLLocation?) -> LocationDTO? {
    guard let location = location else { return nil }
    let locationDTO = LocationDTO(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    return locationDTO
  }

}

// MARK: - Data Transfer Object translate to model
extension ModelTranslator {
  
  func translate(dto: CityDTO, in realm: Realm? = RealmProvider.core.realm) -> City {
    let city = City(name: dto.name,
                    country: dto.country,
                    state: dto.state,
                    postalCode: dto.postalCode,
                    timeZoneName: dto.timeZoneName,
                    location: translate(dto: dto.location),
                    isUserLocation: dto.isUserLocation)
    return city
  }
  
  func translate(dto: LocationDTO) -> CLLocation {
    return CLLocation(latitude: dto.latitude, longitude: dto.longitude)
  }
  
}
