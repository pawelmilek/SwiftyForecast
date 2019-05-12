protocol CityViewModel {
  var name: String { get }
  var currentTime: String { get }
  var service: ForecastService { get }
  
  init(city: City, service: ForecastService)
}
