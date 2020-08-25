import MapKit

protocol LocationSearchResultsTableViewControllerDelegate: class {
  func locationSearch(_ view: LocationSearchResultsTableViewController, willDropPinZoomIn placemark: MKPlacemark)
}
