protocol CityViewModel {
  var name: String { get }
  var localTime: String { get }
  
  init(city: CityRealm, service: ForecastService, delegate: CityViewModelDelegate?)
}
