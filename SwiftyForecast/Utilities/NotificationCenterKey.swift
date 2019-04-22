//
//  NotificationCenterKey.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 01/10/18.
//  Copyright © 2016 Pawel Milek. All rights reserved.
//

import Foundation

enum NotificationCenterKey: String {
  case measuringSystemDidSwitchNotification = "MeasuringSystemDidSwitch"
  case refreshButtonDidPressNotification = "RefreshButtonDidPress"
  case reloadPagesNotification = "ReloadPagesNotification"
  case reloadPagesDataNotification = "ReloadPagesDataNotification"
  case locationServiceDidBecomeEnable = "locationServiceDidBecomeEnableNotification"
}


extension NotificationCenterKey {
  
  var name: NSNotification.Name {
    return NSNotification.Name(rawValue: self.rawValue)
  }
  
}
