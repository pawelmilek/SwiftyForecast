//
//  CurrentForecastViewDelegate.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 03/07/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

protocol CurrentForecastViewDelegate: class {
  func currentForecastDidExpand()
  func currentForecastDidCollapse()
}
