protocol CityTableViewControllerDelegate: AnyObject {
  func cityTableViewController(_ cityTableViewController: CityTableViewController, didSelect city: City)
}
