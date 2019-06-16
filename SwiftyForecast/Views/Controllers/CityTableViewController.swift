import UIKit
import CoreData
import GooglePlaces

class CityTableViewController: UITableViewController, UsesCoreDataObjects {
  typealias ForecastCityStyle = Style.ForecastCityListVC
  
  private lazy var autocompleteController: GMSAutocompleteViewController = {
    let autocompleteVC = GMSAutocompleteViewController()
    autocompleteVC.delegate = self
    autocompleteVC.primaryTextColor = ForecastCityStyle.autocompleteVCPrimaryTextColor
    autocompleteVC.primaryTextHighlightColor = ForecastCityStyle.autocompleteVCPrimaryTextHighlightColor
    autocompleteVC.secondaryTextColor = ForecastCityStyle.autocompleteVCSecondaryTextColor
    autocompleteVC.tableCellSeparatorColor = ForecastCityStyle.autocompleteVCTableCellSeparatorColor
    autocompleteVC.setSearchTextInSearchBar(color: ForecastCityStyle.autocompleteVCSSearchTextColorInSearchBar, andFont: ForecastCityStyle.autocompleteVCSSearchTextFontInSearchBar)
    autocompleteVC.setSearchTextFieldPlaceholder(color: ForecastCityStyle.autocompleteVCSearchTextFieldColorPlaceholder, andFont: ForecastCityStyle.autocompleteVCSearchTextFieldFontPlaceholder)
    autocompleteVC.setSearchBarCancelButton(color: ForecastCityStyle.autocompleteVCSearchBarCancelButtonColor, andFont: ForecastCityStyle.autocompleteVCSearchBarCancelButtonFont)
    return autocompleteVC
  }()
  
  private lazy var footerView: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
    let addButton = UIButton(frame: .zero)
    
    addButton.translatesAutoresizingMaskIntoConstraints = false
    addButton.setBackgroundImage(UIImage(named: "ic_add"), for: .normal)
    addButton.addTarget(self, action: #selector(addNewCityButtonTapped(_:)), for: .touchUpInside)
    
    view.addSubview(addButton)
    addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    addButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    view.centerXAnchor.constraint(equalTo: addButton.centerXAnchor).isActive = true
    view.centerYAnchor.constraint(equalTo: addButton.centerYAnchor).isActive = true
    return view
  }()
  
  private var cities: [City] = []
  private var citiesTimeZone: [String: TimeZone] = [:]
  weak var delegate: CityTableViewControllerDelegate?
  var managedObjectContext: NSManagedObjectContext?
//  var viewModel: ForecastCityViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
}

// MARK: - ViewSetupable protocol
extension CityTableViewController: ViewSetupable {
  
  func setUp() {
    setTableView()
    fetchCities()
  }
  
}

// MARK: - Private - Set tableview
private extension CityTableViewController {
  
  func setTableView() {
    tableView.register(cellClass: CityTableViewCell.self)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorStyle = .none
    tableView.tableFooterView = footerView
    setTransparentTableViewBackground()
  }
  
}

// MARK: - Private - Set transparent background of TableView
private extension CityTableViewController {
  
  func setTransparentTableViewBackground() {
    let backgroundImage = UIImage(named: "swifty_background")
    let imageView = UIImageView(image: backgroundImage)
    imageView.contentMode = .scaleAspectFill
    
    tableView.backgroundView = imageView
    tableView.backgroundColor = ForecastCityStyle.tableViewBackgroundColor
  }
  
}

// MARK: - Private - Fetch cities and local time
private extension CityTableViewController {
  
  func fetchCities() {
    guard let managedObjectContext = managedObjectContext else { return }
    let fetchRequest = City.createFetchRequest()
    let currentLocalizedSort = NSSortDescriptor(key: "isCurrentLocalization", ascending: false)
    fetchRequest.sortDescriptors = [currentLocalizedSort]
    
    do {
      cities = try managedObjectContext.fetch(fetchRequest)
    } catch {
      CoreDataError.couldNotFetch.handle()
    }
  }
  
}

// MARK: - Private - Insert/Delete city
private extension CityTableViewController {
  
  func insert(city: City) {
    guard city.isExists() == false else { return }
    guard let managedObjectContext = managedObjectContext else { return }
    
    let newCity = City(unassociatedObject: city, isCurrentLocalization: false, managedObjectContext: managedObjectContext)
    
    do {
      try managedObjectContext.save()
      cities.append(newCity)
    } catch {
      CoreDataError.couldNotSave.handle()
    }
  }
  
  func deleteCity(at indexPath: IndexPath) {
    guard let managedObjectContext = managedObjectContext else { return }
    
    let removed = cities.remove(at: indexPath.row)
    let request = City.createFetchRequest()
    let predicate = NSPredicate(format: "name == %@ AND country == %@", removed.name, removed.country)
    request.predicate = predicate
    
    
    if let result = try? managedObjectContext.fetch(request) {
      result.forEach {
        managedObjectContext.delete($0)
      }
      
      do {
        try managedObjectContext.save()
      } catch {
        CoreDataError.couldNotSave.handle()
      }
    }
  }
  
}

// MARK: - Private - Reload pages
private extension CityTableViewController {
  
  func reloadAndInitializeMainPageViewController() {
    NotificationAdapter.post(.reloadPages)
  }
  
}

// MARK: - UITableViewDataSource protocol
extension CityTableViewController {
  
  // TODO: Implement ForecastCityViewModel
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cities.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(CityTableViewCell.self, for: indexPath)
    let row = indexPath.row
    let city = cities[row]
    
    cell.tag = row
    
    if let _ = city.timeZone {
      cell.configure(by: city)
      
    } else {
      if let timeZone = citiesTimeZone["\(row)"] {
        city.timeZone = timeZone
        cell.configure(by: city)
        
      } else {
        let coordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
        fetchTimeZone(from: coordinate) { timeZone in
          self.citiesTimeZone["\(row)"] = timeZone
          if cell.tag == row {
            city.timeZone = timeZone
            do {
              try self.managedObjectContext?.save()
            
            } catch {
              CoreDataError.couldNotSave.handle()
            }
            
            cell.configure(by: city)
          }
        }
      }
    }
    
    return cell
  }
  
}

// MARK: - UITableViewDelegate protocol
extension CityTableViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedCity = cities[indexPath.row]
    delegate?.cityTableViewController(self, didSelect: selectedCity)
    backButtonTapped(.none)
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return indexPath.row == 0 ? false : true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      deleteCity(at: indexPath)
      tableView.deleteRows(at: [indexPath], with: .fade)
      reloadAndInitializeMainPageViewController()
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
}

// MARK: GMSAutocompleteViewControllerDelegate protocol
extension CityTableViewController: GMSAutocompleteViewControllerDelegate {
  
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {    
    let selectedCity = City(place: place)
    
    self.insert(city: selectedCity)
    self.tableView.reloadData()
    self.reloadAndInitializeMainPageViewController()
    self.dismiss(animated: true, completion: nil)
  }
  
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    AlertViewPresenter.shared.presentError(withMessage: "Error: \(error.localizedDescription)")
  }
  
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }
  
  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
  
}

// MARK: - Private - Actions
private extension CityTableViewController {
  
  @objc func backButtonTapped(_ sender: UIButton?) {
    guard let _ = navigationController?.popViewController(animated: true) else {
      self.dismiss(animated: true)
      return
    }
  }
  
  @objc func addNewCityButtonTapped(_ sender: UIButton) {
    present(autocompleteController, animated: true)
  }
  
}

// MARK: - Private - Fetch local time
private extension CityTableViewController {
  
  func fetchTimeZone(from locationCoordinate: CLLocationCoordinate2D, completionHandler: @escaping (_ timeZone: TimeZone?) -> ()) {
    GeocoderHelper.findTimeZone(at: locationCoordinate) { timezone, error in
      if let timezone = timezone {
        completionHandler(timezone)
        
      } else {
        completionHandler(nil)
      }
    }
  }
  
}