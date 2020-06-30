protocol CitySelectionViewControllerDelegate: AnyObject {
  func citySelection(_ view: CitySelectionViewController, didSelect city: City)
}
