import MapKit

protocol LocationSearchTableViewControllerDelegate: class {
  func locationSearch(_ view: LocationSearchTableViewController, willDropPinZoomIn placemark: MKPlacemark)
}
