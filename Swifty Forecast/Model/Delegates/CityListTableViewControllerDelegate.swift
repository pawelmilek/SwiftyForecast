//
//  CityListTableViewControllerDelegate.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 28/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation

protocol CityListTableViewControllerDelegate: class {
  func cityListController(_ cityListTableViewController: ForecastCityListTableViewController, didSelect city: City)
}
