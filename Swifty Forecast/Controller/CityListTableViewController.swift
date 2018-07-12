//
//  CityListTableViewController.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import UIKit

class CityListTableViewController: UITableViewController {
  var dataSourceDelegate: CityListTableDataSourceDelegate?
  var delegate: CityListSelectDelegate?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setup()
    self.setupStyle()
  }
  
}


// MARK: - Prepare For Segue
extension CityListTableViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier, identifier == SegueIdentifierType.addCitySegue.rawValue else { return }
    guard let navController = segue.destination as? UINavigationController,
          let newCityVC = navController.topViewController as? NewCityViewController else { return }
      
      newCityVC.delegate = self
  }
}


// MARK: - ViewSetupable protocol
extension CityListTableViewController: ViewSetupable {
  
  func setup() {
    dataSourceDelegate = CityListTableDataSource()
    
    self.tableView.register(cellClass: CityTableViewCell.self)
    self.tableView.dataSource = dataSourceDelegate
    self.tableView.delegate = self
  }
  
  
  func setupStyle() {
    self.navigationItem.title = "City List"
    self.tableView.separatorColor = .white
    
    
    func setTransparentTableViewBackground() {
      let backgroundImage = UIImage(named: "background-default.png")
      let imageView = UIImageView(image: backgroundImage)
      imageView.contentMode = .scaleAspectFill
      
      self.tableView.backgroundView = imageView
      self.tableView.backgroundColor = .clear
      self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    setTransparentTableViewBackground()
  }
}


// MARK: - NewCityControllerDelegate protocol
extension CityListTableViewController: NewCityControllerDelegate {
  
  func newCityControllerDidAdd(_ newCityController: NewCityViewController, city: City) {
    let insertIndexPath = IndexPath(row: 0, section: 0)
    
    newCityController.dismiss(animated: true) {
      let row = insertIndexPath.row
      
      self.tableView.scrollToRow(at: insertIndexPath, at: .top, animated: true)
      Database.shared.insert(city: city, at: row)
      self.tableView.insertRows(at: [insertIndexPath], with: .automatic)
    }
    
  }
  
  
  func newContactViewControllerDidCancel(_ newCityController: NewCityViewController) {
    newCityController.dismiss(animated: true, completion: nil)
  }
  
}


// MARK: - UITableViewDelegate protocol
extension CityListTableViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let selectedCity = dataSourceDelegate?.city(at: indexPath) else { return }
    
    delegate?.cityListDidSelect(city: selectedCity)
    
    guard let _ = navigationController?.popViewController(animated: true) else {
      self.dismiss(animated: true)
      return
    }
  }
}
