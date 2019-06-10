struct DefaultCityViewModel: CityViewModel {
  let name: String
  let currentTime: String
  let localTime: String
  let service: ForecastService
  
  init(city: City, service: ForecastService) {
    name = city.name + ", " + city.country
    currentTime = ""
    localTime = ""
    self.service = service
  }
}
