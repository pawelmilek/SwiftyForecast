//
//  AddNewCityViewController.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit
import Foundation
import GooglePlacesSearchController


class AddNewCityViewController: UIViewController, GooglePlacesAutocompleteViewControllerDelegate {
  func viewController(didAutocompleteWith place: PlaceDetails) {
    print(place)
  }
  
//  @IBOutlet private weak var searchBar: CitySearchBar!
//  @IBOutlet private weak var searchResultTableView: UITableView!
  
  private lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView(frame: self.view.frame)
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.image = UIImage(named: "background-default.png")
    return imageView
  }()
  
  private let googlePlacesSearchControllerAPIKey = "AIzaSyBRU9w0-Tlx3HWnQg13QnlXyngHHJoakkU"
  
  private var isSearchBarActive = true
  weak var delegate: NewCityControllerDelegate?
  var controller: GooglePlacesSearchController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    controller = GooglePlacesSearchController(delegate: self, apiKey: googlePlacesSearchControllerAPIKey)
    self.navigationController?.pushViewController(controller, animated: true)
    
//    setup()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    searchBar.becomeFirstResponder()
  }
}


// MARK: - ViewSetupable protocol
extension AddNewCityViewController: ViewSetupable {
  
  func setup() {
    setSearchBar()
    setSearchResultTableView()
    setBackgroundImageView()
  }
  
}


// MARK: - Private - Set backgroundImageView
private extension AddNewCityViewController {
  
  func setSearchBar() {
//    searchBar.delegate = self
  }
  
  func setSearchResultTableView() {
    //    searchResultTableView.register(cell: RestaurantMapTableViewCell.self)
    
    //    searchResultTableView.dataSource = dataSource
    //    searchResultTableView.delegate = dataSource
//    searchResultTableView.rowHeight = UITableViewAutomaticDimension
//    searchResultTableView.estimatedRowHeight = 100
//    searchResultTableView.backgroundColor = .clear
//    searchResultTableView.tableFooterView = UIView()
  }
  
  
  func setBackgroundImageView() {
    view.insertSubview(backgroundImageView, at: 0)
  }
  
}


// MARK: - UITextFieldDelegate protocol
extension AddNewCityViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}


// MAKR: Actions
private extension AddNewCityViewController {
  
  @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
    self.hideKeyboard()
    self.delegate?.newContactViewControllerDidCancel(self)
  }
  
  
  @IBAction func saveTapped(_ sender: UIBarButtonItem) {
    //    var isCityNameNilOrEmpty: Bool {
    //      guard let name = self.cityName.text else { return true }
    //      return (name.trimmingCharacters(in: .whitespaces) == "") ? true : false
    //    }
    //
    //    var isCountryNameNilOrEmpty: Bool {
    //      guard let country = self.countryName.text else { return true }
    //      return (country.trimmingCharacters(in: .whitespaces) == "") ? true : false
    //    }
    //
    //
    //    if isCityNameNilOrEmpty {
    //      AlertViewPresenter.shared.presentError(withMessage: "Check City Name text field.")
    //      return
    //    }
    //
    //    if isCountryNameNilOrEmpty {
    //      AlertViewPresenter.shared.presentError(withMessage: "Check Country Name text field.")
    //      return
    //    }
    //
    //    self.hideKeyboard()
    //
    //    let trimName = self.cityName.text!.trimmingCharacters(in: .whitespaces)
    //    let trimCountry = self.countryName.text!.trimmingCharacters(in: .whitespaces)
    //
    //
    //    Geocoder.findCoordinate(by: "\(trimName), \(trimCountry)") { coord in
    //      let newCity = City(name: trimName, country: trimCountry, coordinate: coord)
    //      self.delegate?.newCityControllerDidAdd(self, city: newCity)
    //    }
  }
  
}



// MARK: - UISearchBarDelegate protocol
extension AddNewCityViewController: UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    isSearchBarActive = true
    searchBar.setShowsCancelButton(true, animated: true)
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    isSearchBarActive = false
    searchBar.setShowsCancelButton(false, animated: true)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//    if isListView == false {
//      renderListView()
//      searchBar.becomeFirstResponder()
//    }
//    filter(for: searchText)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//    filter(for: searchBar.text ?? "")
    searchBar.resignFirstResponder()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(false, animated: true)
    isSearchBarActive = false
    searchBar.text = ""
    searchBar.resignFirstResponder()
    self.dismiss(animated: true)
  }
  
}


// MAKR: Close Keyboard
private extension AddNewCityViewController {
  
  func hideKeyboard() {
    for view in view.subviews {
      if view.isFirstResponder {
        view.resignFirstResponder()
      }
    }
  }
  
}
