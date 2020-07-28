import MapKit

final class DefaultLocationSearchTableViewModel: LocationSearchTableViewModel {
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
    return parseAddress(of: placemark)
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
    // put a space between "4" and "Melrose Place"
    let firstSpace = (selectedPlacemark.subThoroughfare != nil && selectedPlacemark.thoroughfare != nil) ? " " : ""
    // put a comma between street and city/state
    let comma = (selectedPlacemark.subThoroughfare != nil || selectedPlacemark.thoroughfare != nil) && (selectedPlacemark.subAdministrativeArea != nil || selectedPlacemark.administrativeArea != nil) ? ", " : ""
    // put a space between "Washington" and "DC"
    let secondSpace = (selectedPlacemark.subAdministrativeArea != nil && selectedPlacemark.administrativeArea != nil) ? " " : ""
    let addressLine = String(
      format:"%@%@%@%@%@%@%@",
      // street number
      selectedPlacemark.subThoroughfare ?? "",
      firstSpace,
      // street name
      selectedPlacemark.thoroughfare ?? "",
      comma,
      // city
      selectedPlacemark.locality ?? "",
      secondSpace,
      // state
      selectedPlacemark.administrativeArea ?? ""
    )
    return addressLine
  }
}
