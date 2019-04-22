import Foundation

protocol CityListTableViewControllerDelegate: AnyObject {
  func cityListController(_ cityListTableViewController: ForecastCityListTableViewController, didSelect city: City)
}
