import MapKit

protocol CitySelectionViewModel {
  var numberOfCities: Int { get }

  var onSuccess: (() -> Void)? { get set }
  var onFailure: ((Error) -> Void)? { get set }
  var onLoadingStatus: ((Bool) -> Void)? { get set }

  init(delegate: CitySelectionViewModelDelegate)
  
  func select(at index: Int)
  func name(at index: Int) -> String
  func localTime(at index: Int) -> String
  func map(at index: Int) -> (annotation: MKPointAnnotation, region: MKCoordinateRegion)?
}
