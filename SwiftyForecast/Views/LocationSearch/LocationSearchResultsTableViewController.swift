import UIKit
import MapKit

final class LocationSearchResultsTableViewController: UITableViewController {
  weak var locationSearchDelegate: LocationSearchResultsTableViewControllerDelegate?
  var viewModel: LocationSearchResultsViewModel?
  var mapView: MKMapView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  deinit {
    debugPrint("File: \(#file), Function: \(#function), line: \(#line) deinit LocationSearchResultsTableViewController")
  }
}

// MARK: - Private - SetUps
private extension LocationSearchResultsTableViewController {
  
  func setUp() {
    tableView.separatorColor = Style.LocationSearch.separatorColor
    tableView.backgroundColor = Style.LocationSearch.backgroundColor
    
    viewModel?.onUpdateSearchResults = { [weak self] in
      self?.tableView.reloadData()
    }
  }
  
}

// MARK: - UITableViewDataSource delegate
extension LocationSearchResultsTableViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.matchingItemsCount ?? 0
  }
  
}

// MARK: - UITableViewDelegate delegate
extension LocationSearchResultsTableViewController {

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
extension LocationSearchResultsTableViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let mapView = mapView, let searchBarText = searchController.searchBar.text else { return }
    viewModel?.localSearchRequest(search: searchBarText, at: mapView.region)
  }

}

// MARK: - Factory method
extension LocationSearchResultsTableViewController {
  
  static func make(with mapView: MKMapView) -> LocationSearchResultsTableViewController {
    let viewController = StoryboardViewControllerFactory.make(LocationSearchResultsTableViewController.self,
                                                              from: .locationSearch)
    viewController.mapView = mapView
    viewController.viewModel = DefaultLocationSearchResultsViewModel()
    return viewController
  }
}
