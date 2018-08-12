//
//  NotificationCenterKey.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 01/10/16.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation

enum NotificationCenterKey: String {
  case measuringSystemDidSwitchNotification = "MeasuringSystemDidSwitch"
  case refreshButtonDidPressNotification = "RefreshButtonDidPress"
  case reloadPagesNotification = "ReloadPagesNotification"
}


extension NotificationCenterKey {
  
  var name: NSNotification.Name {
    return NSNotification.Name(rawValue: self.rawValue)
  }
  
}
