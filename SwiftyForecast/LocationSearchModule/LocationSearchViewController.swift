import UIKit
import MapKit
import CoreLocation

final class LocationSearchViewController: UIViewController {
  @IBOutlet private weak var mapView: MKMapView!
  
  weak var coordinator: MainCoordinator?
  private let sharedLocationProvider = LocationProvider.shared
  private lazy var searchController: UISearchController? = {
    let viewController = LocationSearchResultsTableViewController.make(with: mapView)
    viewController.locationSearchDelegate = self
    
    let searchController = UISearchController(searchResultsController: viewController)
    searchController.searchResultsUpdater = viewController
    searchController.searchBar.tintColor = Style.LocationSearch.searchTextColorInSearchBar
    searchController.searchBar.barTintColor = Style.LocationSearch.searchBarCancelButtonColor
    searchController.searchBar.backgroundColor = Style.LocationSearch.backgroundColor
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
    navigationItem.titleView = searchController?.searchBar
  }
  
  func resetSearchController() {
    searchController?.isActive = false
    searchController?.searchBar.text = nil
    searchController?.searchBar.resignFirstResponder()
  }
  
}

// MARK: - Private - Requrest location
private extension LocationSearchViewController {
  
  func requestLocation() {
    sharedLocationProvider.request { location in
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
    mapView.selectAnnotation(annotation, animated: true)
  }
  
}

// MARK: - CityCalloutViewDelegate delegate
extension LocationSearchViewController: MapCalloutViewControllerDelegate {

  func calloutViewController(didAdd city: CityDTO) {
    dismiss(animated: true) { [weak self] in
      self?.searchController = nil
      self?.coordinator?.onAddCityFromCalloutViewController()
    }
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
    let viewModel = DefaultMapCalloutViewModel(placemark: selectedPin, delegate: self)
    let viewController = MapCalloutViewController.make(viewModel: viewModel)
    viewController.modalPresentationStyle = .popover

    if let popoverPresentationController = viewController.popoverPresentationController {
      popoverPresentationController.permittedArrowDirections = .down
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
