final class DefaultCitySelectionViewModel: CitySelectionViewModel {
  let name: String
  let localTime: String
  
  var onError: ((Error) -> Void)?
  var onUpdateLoadingStatus: ((Bool) -> Void)?
  
  private let city: City
  private let service: ForecastService
  private weak var delegate: CityViewModelDelegate?
  
  init(city: City, service: ForecastService, delegate: CityViewModelDelegate?) {
    name = city.name + ", " + city.country
    localTime = city.localTime

    self.city = city
    self.service = service
    self.delegate = delegate
    fetchCites()
  }
}

// MARK: - Private - Fetch cities
private extension DefaultCitySelectionViewModel {
  
  func fetchCites() {
    onUpdateLoadingStatus?(true)
    
    guard let location = city.location else {
      onError?(WebServiceError.requestFailed)
      return
    }
    
    service.getForecast(by: location) { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .success(let data):
          self.delegate?.dataDidLoad("\(data)")
        
      case .failure:
        self.onError?(WebServiceError.requestFailed)
      }
      self.onUpdateLoadingStatus?(false)
    }
  }

}
