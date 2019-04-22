import Foundation

struct DefaultCityViewModel: CityViewModel {
  var name: String
  var currentTime: String
  var service: ForecastService
  
  init(city: City, service: ForecastService) {
    name = city.name + ", " + city.country
    currentTime = ""
    self.service = service
  }
}
