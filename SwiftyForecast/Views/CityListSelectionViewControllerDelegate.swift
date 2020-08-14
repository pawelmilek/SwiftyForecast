protocol CityListSelectionViewControllerDelegate: AnyObject {
  func citySelection(_ view: CityListSelectionViewController, didSelect city: City)
}
