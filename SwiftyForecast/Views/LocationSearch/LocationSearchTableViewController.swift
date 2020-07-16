import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

final class LocationSearchTableViewController: UITableViewController {
  var handleMapSearchDelegate: HandleMapSearch? = nil
  var matchingItems: [MKMapItem] = []
  var mapView: MKMapView? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  func parseAddress(selectedItem:MKPlacemark) -> String {
    // put a space between "4" and "Melrose Place"
    let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
    // put a comma between street and city/state
    let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
    // put a space between "Washington" and "DC"
    let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
    let addressLine = String(
      format:"%@%@%@%@%@%@%@",
      // street number
      selectedItem.subThoroughfare ?? "",
      firstSpace,
      // street name
      selectedItem.thoroughfare ?? "",
      comma,
      // city
      selectedItem.locality ?? "",
      secondSpace,
      // state
      selectedItem.administrativeArea ?? ""
    )
    return addressLine
  }
}

// MARK: - Private - SetUps
private extension LocationSearchTableViewController {
  
  func setUp() {
    
  }
  
}

// MARK: - UITableViewDataSource delegate
extension LocationSearchTableViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return matchingItems.count
  }
  
}

// MARK: - UITableViewDelegate delegate
extension LocationSearchTableViewController {

   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
    let selectedItem = matchingItems[indexPath.row].placemark
    
    cell.textLabel?.text = selectedItem.name
    cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
    
    return cell
   }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedItem = matchingItems[indexPath.row].placemark
    handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
    dismiss(animated: true)
  }

}

// MARK: - UISearchResultsUpdating protocol
extension LocationSearchTableViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let mapView = mapView, let searchBarText = searchController.searchBar.text else { return }

    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = searchBarText
    request.region = mapView.region
    let search = MKLocalSearch(request: request)
    search.start { response, _ in
      guard let response = response else { return }
      self.matchingItems = response.mapItems
      self.tableView.reloadData()
    }
  }
  
}
