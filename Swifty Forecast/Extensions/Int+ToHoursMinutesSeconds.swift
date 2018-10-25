//
//  Int+ToHoursMinutesSeconds.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 16/10/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

extension Int {
  
  var convertToHoursMinutesSeconds: (hours: Int, minutes: Int, seconds: Int) {
    return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
  }
  
}
