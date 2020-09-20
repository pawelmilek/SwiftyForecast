import MapKit

protocol LocationSearchResultsViewModel {
  var matchingItems: [MKMapItem] { get set }
  var matchingItemsCount: Int { get }
  
  var onUpdateSearchResults: (() -> Void)? { get set }
  
  func item(at index: Int) -> MKPlacemark?
  func name(at index: Int) -> String?
  func address(at index: Int) -> String?
  
  func localSearchRequest(search text: String, at region: MKCoordinateRegion)
}
