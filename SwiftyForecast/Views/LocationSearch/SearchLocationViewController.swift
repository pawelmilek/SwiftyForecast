import UIKit
import MapKit
import CoreLocation

final class SearchLocationViewController: UIViewController {
  @IBOutlet private weak var mapView: MKMapView!
  @IBOutlet private weak var searchLocationTextField: SearchTextField!
  
  weak var coordinator: MainCoordinator?
  
  private lazy var searchController: UISearchController = {
    let viewController = LocationSearchTableViewController.make(with: mapView)
    viewController.locationSearchDelegate = self
    
    let searchController = UISearchController(searchResultsController: viewController)
    searchController.searchResultsUpdater = viewController
    searchController.searchBar.tintColor = Style.LocationSearch.searchTextColorInSearchBar
    searchController.searchBar.barTintColor = Style.LocationSearch.searchBarCancelButtonColor
    searchController.searchBar.backgroundColor = .white
    searchController.searchBar.sizeToFit()
    searchController.searchBar.placeholder = "Search places"
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    definesPresentationContext = true
    return searchController
  }()
  
  private var selectedPin: MKPlacemark? = nil
  private let sharedLocationProvider = LocationProvider.shared
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    requrestLocation()
  }
  
  deinit {
    debugPrint("deinit SearchLocationViewController")
  }
}

// MARK: - Private - SetUps
private extension SearchLocationViewController {
  
  func setUp() {
    setMapView()
    removeBackButtonTitle()
    setupSearchController()
  }
  
  func setMapView() {
    mapView.delegate = self
    mapView.showsUserLocation = true
  }
  
  func removeBackButtonTitle() {
    let button = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationController?.navigationBar.topItem?.backBarButtonItem = button
  }
  
  func setupSearchController() {
    navigationItem.titleView = searchController.searchBar
  }
  
  func resetSearchController() {
    searchController.isActive = false
    searchController.searchBar.text = nil
    searchController.searchBar.resignFirstResponder()
  }

}

// MARK: - Private - Requrest location
private extension SearchLocationViewController {
  
  func requrestLocation() {
    sharedLocationProvider.requestLocation { location in
      DispatchQueue.main.async { [weak self] in
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        self?.mapView.setRegion(region, animated: true)
      }
    }
  }

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

// MARK: - LocationSearchTableViewControllerDelegate delegate
extension SearchLocationViewController: LocationSearchTableViewControllerDelegate {
  
  func locationSearch(_ view: LocationSearchTableViewController, willDropPinZoomIn placemark: MKPlacemark) {
    selectedPin = placemark
    mapView.removeAnnotations(mapView.annotations)
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = placemark.coordinate
    annotation.title = placemark.name
    if let city = placemark.locality, let state = placemark.administrativeArea {
      annotation.subtitle = "\(city) \(state)"
    }
    
    mapView.addAnnotation(annotation)
    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
    mapView.setRegion(region, animated: true)
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
