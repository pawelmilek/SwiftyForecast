//
//  MeasuringSystem.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 28/09/18.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation

enum MeasuringSystem {
  case metric
  case imperial
  
  static var selected: MeasuringSystem = .imperial
}
