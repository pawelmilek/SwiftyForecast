import MapKit

protocol CityListViewModel {
  var numberOfCities: Int { get }

  init(delegate: CityListViewModelDelegate)
  
  func delete(at indexPath: IndexPath)
  func select(at index: Int)
  func name(at index: Int) -> String
  func localTime(at index: Int) -> String
  func map(at index: Int) -> (annotation: MKPointAnnotation, region: MKCoordinateRegion)?
  
  func relaodData(initialUpdate: @escaping () -> Void, applyChanges: @escaping (_ deletions: [Int], _ insertions: [Int], _ updates: [Int]) -> Void)
  func onViewWillDisappear()
}
