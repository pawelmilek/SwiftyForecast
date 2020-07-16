import UIKit
import CoreLocation
import RealmSwift

final class CitySelectionViewController: UIViewController {
  typealias ForecastCityStyle = Style.ForecastCityListVC

  @IBOutlet private weak var tableView: UITableView!
  private lazy var searchLocationViewController = SearchLocationViewController.make()
  private lazy var footerView: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
    let addButton = UIButton(frame: .zero)
    
    addButton.translatesAutoresizingMaskIntoConstraints = false
    addButton.setBackgroundImage(UIImage(named: "ic_add"), for: .normal)
    addButton.setBackgroundImage(UIImage(named: "ic_menu"), for: .highlighted)
    addButton.addTarget(self, action: #selector(addNewCityButtonTapped(_:)), for: .touchUpInside)
    
    view.addSubview(addButton)
    addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    addButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    view.centerXAnchor.constraint(equalTo: addButton.centerXAnchor).isActive = true
    view.centerYAnchor.constraint(equalTo: addButton.centerYAnchor).isActive = true
    return view
  }()
  
  private var citiesTimeZone: [String: TimeZone] = [:]
  weak var delegate: CitySelectionViewControllerDelegate?
  var viewModel: CitySelectionViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  deinit {
    debugPrint("deinit CitySelectionTableViewController")
  }
}

// MARK: - ViewSetupable protocol
extension CitySelectionViewController: ViewSetupable {
  
  func setUp() {
    setTableView()
  }
  
}

// MARK: - Private - Set tableview
private extension CitySelectionViewController {
  
  func setTableView() {
    tableView.register(cellClass: CityTableViewCell.self)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorStyle = .none
    tableView.isUserInteractionEnabled = true
    tableView.tableFooterView = footerView
    setTransparentTableViewBackground()
  }

}

// MARK: - Private - Set transparent background of TableView
private extension CitySelectionViewController {
  
  func setTransparentTableViewBackground() {
    let backgroundImage = UIImage(named: "swifty_background")
    let imageView = UIImageView(image: backgroundImage)
    imageView.contentMode = .scaleAspectFill
    
    tableView.backgroundView = imageView
    tableView.backgroundColor = ForecastCityStyle.tableViewBackgroundColor
  }
  
}

// MARK: - Private - Insert/Delete city
private extension CitySelectionViewController {
  
  func insert(city: City) {
//    guard city.isExists() == false else { return }
  }
  
  func deleteCity(at indexPath: IndexPath) {
    
  }
  
}

// MARK: - Private - Reload pages
private extension CitySelectionViewController {
  
  func reloadAndInitializeMainPageViewController() {
//    ForecastNotificationCenter.post(.reloadPages)
  }
  
}

// MARK: - UITableViewDataSource protocol
extension CitySelectionViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.numberOfCities ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let viewModel = viewModel else { return UITableViewCell() }
    let cell = tableView.dequeueCell(CityTableViewCell.self, for: indexPath)
    let row = indexPath.row
    let cityName = viewModel.name(at: row)
    let localTime = viewModel.localTime(at: row)
    cell.tag = row
    
//    if let _ = city.timeZone {
      cell.configure(by: cityName, time: localTime)
      
//    } else {
//      if let timeZone = citiesTimeZone["\(row)"] {
//        city.timeZone = timeZone
//        cell.configure(by: cityName, time: localTime)
//
//      } else {
//        let coordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
//        fetchTimeZone(from: coordinate) { timeZone in
//          self.citiesTimeZone["\(row)"] = timeZone
//          if cell.tag == row {
//            city.timeZone = timeZone
//
//            do {
//              // TODO: Replace with Realm
//              try self.managedObjectContext?.save()
//
//            } catch {
//              CoreDataError.couldNotSave.handler()
//            }
//
//            cell.configure(by: cityName, time: localTime)
//          }
//        }
//      }
//    }
    
    return cell
  }
  
}

// MARK: - UITableViewDelegate protocol
extension CitySelectionViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel?.select(at: indexPath.row)
    self.dismiss(animated: true)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return indexPath.row == 0 ? false : true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      deleteCity(at: indexPath)
      tableView.deleteRows(at: [indexPath], with: .fade)
//      reloadAndInitializeMainPageViewController()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
}

// MARK: - CitySelectionViewModelDelegate protocol
extension CitySelectionViewController: CitySelectionViewModelDelegate {
  
  func didSelect(_ viewModel: CitySelectionViewModel, city: City) {
    delegate?.citySelection(self, didSelect: city)
  }

}

// MARK: GMSAutocompleteViewControllerDelegate protocol
//extension CityTableViewController: GMSAutocompleteViewControllerDelegate {

//  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//    UIApplication.shared.isNetworkActivityIndicatorVisible = true
//  }
//
//  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//  }
  
//}

// MARK: - Private - Actions
private extension CitySelectionViewController {
  
  @objc func addNewCityButtonTapped(_ sender: UIButton) {
    let navigationController = UINavigationController(rootViewController: searchLocationViewController)
    present(navigationController, animated: true)
  }
  
}

// MARK: - Private - Fetch local time
private extension CitySelectionViewController {
  
  func fetchTimeZone(from locationCoordinate: CLLocationCoordinate2D, completionHandler: @escaping (_ timeZone: TimeZone?) -> ()) {
    GeocoderHelper.timeZone(for: locationCoordinate) { result in
      switch result {
      case .success(let data):
        completionHandler(data)
        
      case .failure:
        completionHandler(nil)
      }
    }
  }
  
}

// MARK: - Factory method
extension CitySelectionViewController {
  
  static func make() -> CitySelectionViewController {
    let storyboard = UIStoryboard(storyboard: .main)
    return storyboard.instantiateViewController(CitySelectionViewController.self)
  }

}
