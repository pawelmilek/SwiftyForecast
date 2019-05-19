import Foundation

protocol CityListTableViewControllerDelegate: AnyObject {
  func cityListController(_ cityListTableViewController: ForecastCityTableViewController, didSelect city: City)
}
