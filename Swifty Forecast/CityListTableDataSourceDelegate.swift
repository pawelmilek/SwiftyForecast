//
//  CityListTableDataSourceDelegate.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 27/09/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit


protocol CityListTableDataSourceDelegate: class, UITableViewDataSource {
    func cityAt(index: IndexPath) -> City
}
