struct DefaultCityViewModel: CityViewModel {
  let name: String
  let localTime: String
  private let city: CityRealm
  private let service: ForecastService
  private weak var delegate: CityViewModelDelegate?
  
  init(city: CityRealm, service: ForecastService, delegate: CityViewModelDelegate?) {
    name = city.name + ", " + city.country
    localTime = city.localTime

    self.city = city
    self.service = service
    self.delegate = delegate
    fetchCites()
  }
}

// MARK: - Private - Fetch cities
private extension DefaultCityViewModel {
  
  func fetchCites() {
    guard let location = city.location else {
      delegate?.dataDidLoad(.none)
      return
    }
    
    service.getForecast(by: location, completion: { result in
      switch result {
      case .success(let data):
          self.delegate?.dataDidLoad("\(data)")
        
      case .failure(let error):
        fatalError("getForecast error: \(error.localizedDescription)")
      }
    })
  }

}
