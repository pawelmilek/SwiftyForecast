//
//  ForecastCityListTableViewController.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit
import GooglePlaces

class ForecastCityListTableViewController: UITableViewController {
  private let sharedMOC = CoreDataStackHelper.shared
  
  private lazy var autocompleteController: GMSAutocompleteViewController = {
    let autocompleteVC = GMSAutocompleteViewController()
    autocompleteVC.delegate = self
    
    autocompleteVC.primaryTextColor = .orange
    autocompleteVC.primaryTextHighlightColor =  UIColor.orange.withAlphaComponent(0.6)
    autocompleteVC.secondaryTextColor = .blackShade
    autocompleteVC.tableCellSeparatorColor = UIColor.blackShade.withAlphaComponent(0.7)
    autocompleteVC.setSearchTextInSearchBar(color: .orange, andFont: UIFont.systemFont(ofSize: 14, weight: .light))
    autocompleteVC.setSearchTextFieldPlaceholder(color: UIColor.blackShade.withAlphaComponent(0.6), andFont: UIFont.systemFont(ofSize: 14, weight: .regular))
    autocompleteVC.setSearchBarCancelButton(color: .orange, andFont: UIFont.systemFont(ofSize: 14, weight: .regular))
    return autocompleteVC
  }()
  
  
  private lazy var footerView: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
    let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
    let addNewCityButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
    
    backButton.translatesAutoresizingMaskIntoConstraints = false
    backButton.setImage(UIImage(named: "ic_arrow_down"), for: .normal)
    backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    
    addNewCityButton.translatesAutoresizingMaskIntoConstraints = false
    addNewCityButton.setImage(UIImage(named: "ic_add"), for: .normal)
    addNewCityButton.addTarget(self, action: #selector(addNewCityButtonTapped(_:)), for: .touchUpInside)
    
    view.addSubview(backButton)
    view.addSubview(addNewCityButton)
    
    view.leadingAnchor.constraint(equalTo: backButton.leadingAnchor, constant: 0).isActive = true
    view.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
    
    view.trailingAnchor.constraint(equalTo: addNewCityButton.trailingAnchor, constant: 8).isActive = true
    view.centerYAnchor.constraint(equalTo: addNewCityButton.centerYAnchor).isActive = true
    
    return view
  }()
  
  private var cities: [City] = []
  weak var delegate: CityListTableViewControllerDelegate?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setup()
    self.setupStyle()
  }
}


// MARK: - ViewSetupable protocol
extension ForecastCityListTableViewController: ViewSetupable {
  
  func setup() {
    setTableview()
    fetchCities()
  }
  
  
  func setupStyle() {
    tableView.separatorColor = .white
    setTransparentTableViewBackground()
  }
}


// MARK: - Private - Set tableview
private extension ForecastCityListTableViewController {
  
  func setTableview() {
    tableView.register(cellClass: CityTableViewCell.self)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = footerView
  }
  
}


// MARK: - Private - fetch cities
private extension ForecastCityListTableViewController {
  
  func fetchCities() {
    let fetchRequest = City.createFetchRequest()
    
    do {
      cities = try sharedMOC.mainContext.fetch(fetchRequest)
    } catch {
      CoreDataError.couldNotFetch.handle()
    }
    
  }
  
}


// MARK: - Private - Set transparent background of TableView
private extension ForecastCityListTableViewController {
  
  func setTransparentTableViewBackground() {
    let backgroundImage = UIImage(named: "swifty_background")
    let imageView = UIImageView(image: backgroundImage)
    imageView.contentMode = .scaleAspectFill
    
    tableView.backgroundView = imageView
    tableView.backgroundColor = .clear
  }
  
}


// MARK: - Private - Actions
private extension ForecastCityListTableViewController {
  
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



// MARK: - Private - Insert/Delete city
private extension ForecastCityListTableViewController {
  
  func insert(city: City) {
    let managedContex = sharedMOC.mainContext
    let newCity = City(unassociatedObject: city, managedObjectContext: managedContex)
  
    do {
      try managedContex.save()
      cities.append(newCity)
    } catch {
      CoreDataError.couldNotSave.handle()
    }
    
  }
  
  
  func deleteCity(at indexPath: IndexPath) {
    let removed = cities.remove(at: indexPath.row)
    let request = City.createFetchRequest()
    let predicate = NSPredicate(format: "name == %@ AND country == %@ AND coordinate == %@", removed.name, removed.country, removed.coordinate)
    request.predicate = predicate
    
    do {
      if let result = try? sharedMOC.mainContext.fetch(request) {
        result.forEach {
          sharedMOC.mainContext.delete($0)
        }
        
        try sharedMOC.mainContext.save()
      }
      
    } catch {
      CoreDataError.couldNotSave.handle()
    }
  }
  
}


// MARK: - Private - Reload pages
private extension ForecastCityListTableViewController {
  
  func reloadPages() {
    let reloadPagesName = NotificationCenterKey.reloadPagesNotification.name
    NotificationCenter.default.post(name: reloadPagesName, object: nil)
  }
  
}


// MARK: - UITableViewDataSource protocol
extension ForecastCityListTableViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cities.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(CityTableViewCell.self, for: indexPath)
    let item = cities[indexPath.row]
    cell.configure(by: item)
    
    return cell
  }
  
}


// MARK: - UITableViewDelegate protocol
extension ForecastCityListTableViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedCity = cities[indexPath.row]
    delegate?.cityListController(self, didSelect: selectedCity)
    backButtonTapped(.none)
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return indexPath.row == 0 ? false : true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      deleteCity(at: indexPath)
      tableView.deleteRows(at: [indexPath], with: .fade)
      reloadPages()
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 66
  }
  
}


// MARK: GMSAutocompleteViewControllerDelegate protocol
extension ForecastCityListTableViewController: GMSAutocompleteViewControllerDelegate {
  
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    let selectedCity = City(place: place)
    
    insert(city: selectedCity)
    tableView.reloadData()
    reloadPages()
    dismiss(animated: true, completion: nil)
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

