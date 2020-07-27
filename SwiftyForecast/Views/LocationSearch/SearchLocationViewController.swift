import UIKit
import MapKit
import CoreLocation

final class SearchLocationViewController: UIViewController {
  @IBOutlet private weak var mapView: MKMapView!
  @IBOutlet private weak var searchLocationTextField: SearchTextField!
  
  private lazy var searchController: UISearchController = {
    let locationSearchTableViewController = LocationSearchTableViewController.loadFromNib()
    locationSearchTableViewController.mapView = mapView
    locationSearchTableViewController.handleMapSearchDelegate = self

    let searchController = UISearchController(searchResultsController: locationSearchTableViewController)
    searchController.searchResultsUpdater = locationSearchTableViewController
    
//    searchController.searchBar.placeholder = "Search City"
//    searchController.searchBar.delegate = self
//    searchController.searchBar.tintColor = .red
//    searchController.searchBar.barTintColor = .red
//    searchController.searchBar.backgroundColor = .gray
//    searchController.searchBar.searchTextField.backgroundColor = .white
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    definesPresentationContext = true

    return searchController
  }()
  
  private var selectedPin: MKPlacemark? = nil
  weak var coordinator: MainCoordinator?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  deinit {
    debugPrint("deinit SearchLocationViewController")
  }
}

// MARK: - Private - SetUps
private extension SearchLocationViewController {
  
  func setUp() {
    mapView.delegate = self
    mapView.showsUserLocation = true
    navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    setupSearchController()
  }
  
  func setupSearchController() {
    let searchBar = searchController.searchBar
    searchBar.sizeToFit()
    searchBar.placeholder = "Search for places"
    navigationItem.titleView = searchController.searchBar
  }
  
  func resetSearchController() {
    searchController.isActive = false
    searchController.searchBar.text = nil
    searchController.searchBar.resignFirstResponder()
  }
}

// MARK: - Private - SetUps helpers
private extension SearchLocationViewController {
  
  func setTitle() {
    title = "Location"
  }
  
//  func setupSearchTextField() {
//    searchLocationTextField.placeholder = "Search location"
//    searchLocationTextField.font = UIFont.systemFont(ofSize: 13, weight: .light)
//    searchLocationTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
//    searchLocationTextField.layer.cornerRadius = 10
//    searchLocationTextField.delegate = self
//
//    searchLocationTextField.addTarget(self, action:#selector(searchLocationTextFieldDidChange), for: .editingChanged)
//    searchLocationTextField.theme = SearchTextFieldTheme.lightTheme()
//    searchLocationTextField.theme.font = UIFont.systemFont(ofSize: 13, weight: .light)
//    searchLocationTextField.theme.bgColor = UIColor.gray.withAlphaComponent(0.7)
//    searchLocationTextField.theme.borderColor = .clear
//    searchLocationTextField.theme.separatorColor = .gray
//    searchLocationTextField.comparisonOptions = [.caseInsensitive]
//    searchLocationTextField.theme.cellHeight = 50
//    searchLocationTextField.maxNumberOfResults = 4
//  }
  
}

// MARK: - Private - Actions
private extension SearchLocationViewController {
  
  @objc func searchLocationTextFieldDidChange() {
    guard let searchedAddress = searchLocationTextField.text, searchedAddress.count > 0 else { return }
    var addressResult: [String?] = []
    
    debugPrint("File: \(#file), Function: \(#function), line: \(#line)") 
    //    let options = ForwardGeocodeOptions(query: searchedAddress)
    //    options.allowedScopes = [.address, .pointOfInterest]
    
    
    //    Geocoder.shared.geocode(options) { [weak self] placemarks, attribution, error in
    //      guard let self = self else { return }
    //      guard let placemarks = placemarks else { return }
    //
    //      placemarks.forEach {
    //        let coordinate = $0.location?.coordinate
    //        debugPrint("coordinate: \(coordinate)")
    //        addressResult.append($0.qualifiedName)
    //      }
    //
    //      self.searchLocationTextField.filterStrings(addressResult.compactMap { $0 })
    //      self.searchLocationTextField.maxNumberOfResults = 5
    //
    //      self.searchLocationTextField.itemSelectionHandler = { filteredResults, itemPosition in
    //        let item = filteredResults[itemPosition]
    //        self.searchLocationTextField.text = item.title
    //
    //        let geoCoder = CLGeocoder()
    //        geoCoder.geocodeAddressString(item.title) { placemarks, error in
    //          guard let placemarks = placemarks,
    //            let location = placemarks.first?.location,
    //            let placeMark = placemarks.first else {
    //              return
    //          }
    //
    //          // TODO: Save new current locoation in Realm
    //          debugPrint("placemarks: \(placemarks)")
    //        }
    //      }
    //    }
  }
  
}

// MARK: - MKMapViewDelegate delegate
extension SearchLocationViewController: MKMapViewDelegate {
  
}


// MARK: - UISearchBarDelegate protocol
extension SearchLocationViewController: UISearchBarDelegate {
  
}

// MARK: - UISearchResultsUpdating protocol
extension SearchLocationViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text else { return }
  }
  
}

// MARK: - UITextViewDelegate protocol
extension SearchLocationViewController: UITextViewDelegate {
  
}

// MARK: - UITextFieldDelegate protocol
extension SearchLocationViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}

// MARK: - HandleMapSearch delegate
extension SearchLocationViewController: HandleMapSearch {
  
  func dropPinZoomIn(placemark:MKPlacemark) {
    // cache the pin
    selectedPin = placemark
    // clear existing pins
    mapView.removeAnnotations(mapView.annotations)
    let annotation = MKPointAnnotation()
    annotation.coordinate = placemark.coordinate
    annotation.title = placemark.name
    if let city = placemark.locality, let state = placemark.administrativeArea {
      annotation.subtitle = "\(city) \(state)"
    }

    mapView.addAnnotation(annotation)
//    let span = MKCoordinateSpanMake(0.05, 0.05)
//    let region = MKCoordinateRegionMake(placemark.coordinate, span)
//    mapView.setRegion(region, animated: true)
  }

}


// MARK: - Factory method
extension SearchLocationViewController {
  
  static func make() -> SearchLocationViewController {
    let viewController = StoryboardViewControllerFactory.make(SearchLocationViewController.self, from: .locationSearch)
    viewController.isModalInPresentation = true
    return viewController
  }
  
}
