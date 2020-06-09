protocol CitySelectionTableViewControllerDelegate: AnyObject {
  func citySelection(_ view: CitySelectionTableViewController, didSelect city: City)
}
