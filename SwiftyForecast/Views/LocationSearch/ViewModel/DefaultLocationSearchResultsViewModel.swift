import MapKit

final class DefaultLocationSearchResultsViewModel: LocationSearchResultsViewModel {
  var matchingItems = [MKMapItem]()
  var matchingItemsCount: Int {
    return matchingItems.count
  }
  
  var onUpdateSearchResults: (() -> Void)?
  
  func item(at index: Int) -> MKPlacemark? {
    return matchingItems[safe: index]?.placemark
  }
  
  func name(at index: Int) -> String? {
    guard let placemark = item(at: index) else { return nil }
    return placemark.name
  }
  
  func address(at index: Int) -> String? {
    guard let placemark = item(at: index) else { return nil }
    let addressLine = parseAddress(of: placemark)
    return addressLine
  }
  
  func localSearchRequest(search text: String, at region: MKCoordinateRegion) {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = text
    request.region = region
    
    let search = MKLocalSearch(request: request)
    search.start { [weak self] response, _ in
      guard let response = response else { return }
      self?.matchingItems = response.mapItems
      self?.onUpdateSearchResults?()
    }
  }
  
  private func parseAddress(of selectedPlacemark: MKPlacemark) -> String {
    var firstSpace: String {
      let isAdditionalStreetInfo = (selectedPlacemark.subThoroughfare != nil && selectedPlacemark.thoroughfare != nil)
      return isAdditionalStreetInfo ? " " : ""
    }
    
    var secondSpace: String {
      let isStateInfo = (selectedPlacemark.subAdministrativeArea != nil && selectedPlacemark.administrativeArea != nil)
      return isStateInfo ? " " : ""
    }
    
    var comma: String {
      let isStreetInfo = (selectedPlacemark.subThoroughfare != nil || selectedPlacemark.thoroughfare != nil)
      let isAdministrativeOrStateInfo = (selectedPlacemark.subAdministrativeArea != nil || selectedPlacemark.administrativeArea != nil)
      return isStreetInfo && isAdministrativeOrStateInfo ? ", " : ""
    }
    
    let streetNumber = selectedPlacemark.subThoroughfare ?? ""
    let streetName = selectedPlacemark.thoroughfare ?? ""
    let city = selectedPlacemark.locality ?? ""
    let state = selectedPlacemark.administrativeArea ?? ""
    let addressLine = String(format: "%@%@%@%@%@%@%@", streetNumber, firstSpace, streetName, comma, city, secondSpace, state)
    return addressLine
  }
}
