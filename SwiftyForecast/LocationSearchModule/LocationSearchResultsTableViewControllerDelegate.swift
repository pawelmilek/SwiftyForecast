import MapKit

protocol LocationSearchResultsTableViewControllerDelegate: AnyObject {
  func locationSearch(_ view: LocationSearchResultsTableViewController, willDropPinZoomIn placemark: MKPlacemark)
}
