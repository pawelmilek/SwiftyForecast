import UIKit
import CoreLocation
import RealmSwift

final class CitySelectionViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  
  weak var coordinator: MainCoordinator?
  weak var delegate: CitySelectionViewControllerDelegate?
  var viewModel: CitySelectionViewModel?
  
  private lazy var footerView: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
    let addButton = UIButton(frame: .zero)
    
    addButton.translatesAutoresizingMaskIntoConstraints = false
    addButton.layer.cornerRadius = 15
    addButton.clipsToBounds = true
    addButton.setTitle("Search Location", for: .normal)
    addButton.backgroundColor = Style.CitySelection.addButtonBackgroundColor
    addButton.addTarget(self, action: #selector(searchLocationButtonTapped(_:)), for: .touchUpInside)
    
    view.addSubview(addButton)
    addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
    addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
    addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
    addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
    return view
  }()
  
  private var citiesTimeZone: [String: TimeZone] = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      navigationController?.setNavigationBarHidden(false, animated: animated)
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
    tableView.allowsMultipleSelectionDuringEditing = false
    tableView.tableFooterView = footerView
    tableView.backgroundColor = Style.CitySelection.backgroundColor
    tableView.separatorColor = Style.CitySelection.separatorColor
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
    let map = viewModel.map(at: row)
    cell.tag = row
    cell.configure(by: cityName, time: localTime, annotation: map?.annotation, region: map?.region)

    return cell
  }
  
}

// MARK: - UITableViewDelegate protocol
extension CitySelectionViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel?.select(at: indexPath.row)
    coordinator?.onSelectCityFromAvailableCollection()
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return indexPath.row == 0 ? false : true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    deleteCity(at: indexPath)
    tableView.deleteRows(at: [indexPath], with: .fade)
//      reloadAndInitializeMainPageViewController()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CityTableViewCell.defaultHeight
  }
  
}

// MARK: - CitySelectionViewModelDelegate protocol
extension CitySelectionViewController: CitySelectionViewModelDelegate {
  
  func didSelect(_ viewModel: CitySelectionViewModel, city: City) {
    delegate?.citySelection(self, didSelect: city)
  }

}

// MARK: - Private - Actions
private extension CitySelectionViewController {
  
  @objc func searchLocationButtonTapped(_ sender: UIButton) {
    coordinator?.onSearchLocation()
  }
  
}

//// MARK: - Private - Fetch local time
//private extension CitySelectionViewController {
//
//  func fetchTimeZone(from locationCoordinate: CLLocationCoordinate2D, completionHandler: @escaping (_ timeZone: TimeZone?) -> ()) {
//    GeocoderHelper.timeZone(for: locationCoordinate) { result in
//      switch result {
//      case .success(let data):
//        completionHandler(data)
//
//      case .failure:
//        completionHandler(nil)
//      }
//    }
//  }
//
//}

// MARK: - Factory method
extension CitySelectionViewController {
  
  static func make() -> CitySelectionViewController {
    return StoryboardViewControllerFactory.make(CitySelectionViewController.self, from: .main)
  }

}
