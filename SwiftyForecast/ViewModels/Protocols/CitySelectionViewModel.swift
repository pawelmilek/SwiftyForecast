protocol CitySelectionViewModel {
  var name: String { get }
  var localTime: String { get }
  
  var onError: ((Error) -> Void)? { get set }
  var onUpdateLoadingStatus: ((Bool) -> Void)? { get set }
  
  init(city: City, service: ForecastService, delegate: CityViewModelDelegate?)
}
