//
//  CityListTableViewController.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit
import GooglePlaces

class CityListTableViewController: UITableViewController {
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
    backButton.setImage(UIImage(named: "ic_arrow_left"), for: .normal)
    backButton.addTarget(self, action: #selector(CityListTableViewController.backButtonTapped(_:)), for: .touchUpInside)
    
    addNewCityButton.translatesAutoresizingMaskIntoConstraints = false
    addNewCityButton.setImage(UIImage(named: "ic_add"), for: .normal)
    addNewCityButton.addTarget(self, action: #selector(CityListTableViewController.addNewCityButtonTapped(_:)), for: .touchUpInside)
    
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
extension CityListTableViewController: ViewSetupable {
  
  func setup() {
    tableView.register(cellClass: CityTableViewCell.self)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = footerView
  }
  
  
  func setupStyle() {
    tableView.separatorColor = .white
//    view.backgroundColor = .orange
    setTransparentTableViewBackground()
  }
}


// MARK: - Private - Set transparent background of TableView
private extension CityListTableViewController {
  
  func setTransparentTableViewBackground() {
    let backgroundImage = UIImage(named: "swifty_background")
    let imageView = UIImageView(image: backgroundImage)
    imageView.contentMode = .scaleAspectFill
    
    tableView.backgroundView = imageView
    tableView.backgroundColor = .clear
  }
  
}


// MARK: - Private add new city
private extension CityListTableViewController {
  
  @objc func backButtonTapped(_ sender: UIButton?) {
    guard let _ = navigationController?.popViewController(animated: true) else {
      self.dismiss(animated: true)
      return
    }
  }
  
  
  @objc func addNewCityButtonTapped(_ sender: UIButton) {
    present(autocompleteController, animated: true)
  }
  
  
  func addNewCity(_ city: City) {
    cities.append(city)
    tableView.reloadData()
  }
  
}


// MARK: GMSAutocompleteViewControllerDelegate protocol
extension CityListTableViewController {
  
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
extension CityListTableViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedCity = cities[indexPath.row]
    delegate?.cityListController(self, didSelect: selectedCity)
    backButtonTapped(.none)
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      cities.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
}


// MARK: GMSAutocompleteViewControllerDelegate protocol
extension CityListTableViewController: GMSAutocompleteViewControllerDelegate {
  
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    let selectedCity = City(place: place, managedObjectContext: ManagedObjectContextHelper.shared.mainContext)
    
    addNewCity(selectedCity)
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

