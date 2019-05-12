struct DefaultCityViewModel: CityViewModel {
  var name: String
  var currentTime: String
  var localTime: String
  var service: ForecastService
  
  init(city: City, service: ForecastService) {
    name = city.name + ", " + city.country
    currentTime = ""
    localTime = ""
    self.service = service
  }
}
