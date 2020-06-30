protocol CityViewModel {
  var name: String { get }
  var localTime: String { get }
  
  init(city: City)
}


struct DefaultCityViewModel: CityViewModel {
  var name: String {
    return city.name + ", " + city.country
  }

  var localTime: String {
    return city.localTime
  }
  
  private let city: City
  
  init(city: City) {
    self.city = city
  }
}
