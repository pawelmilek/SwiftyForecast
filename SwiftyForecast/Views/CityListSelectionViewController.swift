import UIKit
import CoreLocation
import RealmSwift

final class CityListSelectionViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  
  weak var coordinator: MainCoordinator?
  weak var delegate: CityListSelectionViewControllerDelegate?
  var viewModel: CityListViewModel?
  
  private lazy var footerView: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 55))
    let addButton = UIButton(frame: .zero)
    
    addButton.translatesAutoresizingMaskIntoConstraints = false
    addButton.layer.cornerRadius = 15
    addButton.clipsToBounds = true
    addButton.setTitle("Search Location", for: .normal)
    addButton.backgroundColor = Style.CityListSelection.addButtonBackgroundColor
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
    relaodData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  deinit {
    debugPrint("deinit CityListSelectionTableViewController")
  }
}

// MARK: - Private - SetUps
private extension CityListSelectionViewController {
  
  func setUp() {
    setTableView()
  }
  
  func relaodData() {
    tableView.reloadData()
  }
  
}

// MARK: - Private - Set tableview
private extension CityListSelectionViewController {
  
  func setTableView() {
    tableView.register(cellClass: CityTableViewCell.self)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.isUserInteractionEnabled = true
    tableView.allowsMultipleSelectionDuringEditing = false
    tableView.tableFooterView = footerView
    tableView.backgroundColor = Style.CityListSelection.backgroundColor
    tableView.separatorStyle = Style.CityListSelection.separatorStyle
    tableView.separatorColor = Style.CityListSelection.separatorColor
  }
  
}

// MARK: - Private - Reload pages
private extension CityListSelectionViewController {
  
  func reloadAndInitializeMainPageViewController() {
    //    ForecastNotificationCenter.post(.reloadPages)
  }
  
}

// MARK: - UITableViewDataSource protocol
extension CityListSelectionViewController: UITableViewDataSource {
  
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
extension CityListSelectionViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel?.select(at: indexPath.row)
    coordinator?.onSelectCityFromAvailableCollection()
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return indexPath.row == 0 ? false : true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    viewModel?.delete(at: indexPath)
    tableView.deleteRows(at: [indexPath], with: .fade)
    //      reloadAndInitializeMainPageViewController()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CityTableViewCell.defaultHeight
  }
  
}

// MARK: - CityListSelectionViewModelDelegate protocol
extension CityListSelectionViewController: CityListViewModelDelegate {
  
  func didSelect(_ viewModel: CityListViewModel, city: City) {
    delegate?.citySelection(self, didSelect: city)
  }
  
}

// MARK: - Private - Actions
private extension CityListSelectionViewController {
  
  @objc func searchLocationButtonTapped(_ sender: UIButton) {
    coordinator?.onSearchLocation()
  }
  
}

// MARK: - Factory method
extension CityListSelectionViewController {
  
  static func make() -> CityListSelectionViewController {
    return StoryboardViewControllerFactory.make(CityListSelectionViewController.self, from: .main)
  }
  
}
