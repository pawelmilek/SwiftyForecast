import UIKit
import MapKit
import CoreLocation

final class LocationSearchViewController: UIViewController {
  @IBOutlet private weak var mapView: MKMapView!
  
  weak var coordinator: MainCoordinator?
  private let sharedLocationProvider = LocationProvider.shared
  private lazy var searchController: UISearchController = {
    let viewController = LocationSearchResultsTableViewController.make(with: mapView)
    viewController.locationSearchDelegate = self
    
    let searchController = UISearchController(searchResultsController: viewController)
    searchController.searchResultsUpdater = viewController
    searchController.searchBar.tintColor = Style.LocationSearch.searchTextColorInSearchBar
    searchController.searchBar.barTintColor = Style.LocationSearch.searchBarCancelButtonColor
    searchController.searchBar.backgroundColor = .white
    searchController.searchBar.sizeToFit()
    searchController.searchBar.placeholder = "Search place"
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    definesPresentationContext = true
    return searchController
  }()
  
  private var selectedPin: MKPlacemark?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    requestLocation()
  }
  
  deinit {
    debugPrint("File: \(#file), Function: \(#function), line: \(#line) deinit LocationSearchViewController")
  }
}

// MARK: - Private - SetUps
private extension LocationSearchViewController {
  
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
private extension LocationSearchViewController {
  
  func requestLocation() {
    sharedLocationProvider.requestLocation { location in
      DispatchQueue.main.async { [weak self] in
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        self?.mapView.setRegion(region, animated: true)
      }
    }
  }
  
}

// MARK: - LocationSearchTableViewControllerDelegate delegate
extension LocationSearchViewController: LocationSearchResultsTableViewControllerDelegate {
  
  func locationSearch(_ view: LocationSearchResultsTableViewController, willDropPinZoomIn placemark: MKPlacemark) {
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

// MARK: - CityCalloutViewDelegate delegate
extension LocationSearchViewController: AddCalloutViewControllerDelegate {
  
  func addCalloutViewController(_ view: AddCalloutViewController, didPressAdd button: UIButton) {
    debugPrint("File: \(#file), Function: \(#function), line: \(#line) didPressAdd")
  }
  
}

// MARK: - MKMapViewDelegate delegate
extension LocationSearchViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let selectedPin = selectedPin else { return }
    
    mapView.deselectAnnotation(view.annotation, animated: true)
    showPopover(base: view, for: selectedPin)
  }
  
}

// MARK: - Show add callout view controller as popover
extension LocationSearchViewController {
  
  func showPopover(base: UIView, for selectedPin: MKPlacemark) {
    let viewController = StoryboardViewControllerFactory.make(AddCalloutViewController.self, from: .locationSearch)
    viewController.configure(placemark: selectedPin, delegate: self)
    viewController.modalPresentationStyle = .popover

    if let popoverPresentationController = viewController.popoverPresentationController {
      popoverPresentationController.permittedArrowDirections = .up
      popoverPresentationController.sourceView = base
      popoverPresentationController.sourceRect = base.bounds
      popoverPresentationController.delegate = self
      self.present(viewController, animated: true)
    }
  }
  
}

// MARK: - UIPopoverPresentationControllerDelegate delegate
extension LocationSearchViewController: UIPopoverPresentationControllerDelegate {
  
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
  
  func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    debugPrint("File: \(#file), Function: \(#function), line: \(#line) popoverPresentationController")
  }
  
  func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
    return true
  }
  
}

// MARK: - Factory method
extension LocationSearchViewController {
  
  static func make() -> LocationSearchViewController {
    let viewController = StoryboardViewControllerFactory.make(LocationSearchViewController.self, from: .locationSearch)
    viewController.isModalInPresentation = true
    return viewController
  }
  
}
