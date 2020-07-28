import UIKit
import MapKit

final class LocationSearchTableViewController: UITableViewController {
  weak var locationSearchDelegate: LocationSearchTableViewControllerDelegate?
  var viewModel: LocationSearchTableViewModel?
  var mapView: MKMapView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
}

// MARK: - Private - SetUps
private extension LocationSearchTableViewController {
  
  func setUp() {
    tableView.separatorColor = Style.LocationSearch.separatorColor
    tableView.backgroundColor = Style.LocationSearch.backgroundColor
    
    viewModel?.onUpdateSearchResults = {
      self.tableView.reloadData()
    }
  }
  
}

// MARK: - UITableViewDataSource delegate
extension LocationSearchTableViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.matchingItemsCount ?? 0
  }
  
}

// MARK: - UITableViewDelegate delegate
extension LocationSearchTableViewController {

   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
    let row = indexPath.row
    cell.textLabel?.text = viewModel?.name(at: row)
    cell.detailTextLabel?.text = viewModel?.address(at: row)
    return cell
   }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let selectedItem = viewModel?.item(at: indexPath.row) else { return }
    locationSearchDelegate?.locationSearch(self, willDropPinZoomIn: selectedItem)
    dismiss(animated: true)
  }

}

// MARK: - UISearchResultsUpdating protocol
extension LocationSearchTableViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let mapView = mapView, let searchBarText = searchController.searchBar.text else { return }
    viewModel?.localSearchRequest(search: searchBarText, at: mapView.region)
  }

}

// MARK: - Factory method
extension LocationSearchTableViewController {
  
  static func make(with mapView: MKMapView) -> LocationSearchTableViewController {
    let viewController = StoryboardViewControllerFactory.make(LocationSearchTableViewController.self,
                                                              from: .locationSearch)
    viewController.mapView = mapView
    viewController.viewModel = DefaultLocationSearchTableViewModel()
    return viewController
  }
}
