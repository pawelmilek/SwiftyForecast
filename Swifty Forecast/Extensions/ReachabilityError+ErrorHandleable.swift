//
//  ReachabilityError+ErrorHandleable.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 07/09/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation
import Reachability

extension ReachabilityError: ErrorHandleable {
  
  public var description: String {
    switch self {
    case .FailedToCreateWithAddress(let cockaddrIn):
      return "Failed to create with address \(cockaddrIn)."
      
    case .FailedToCreateWithHostname(let hostname):
      return "Failed to create with hostname \(hostname)."
      
    case .UnableToSetCallback:
      return "Unable to set callback."
      
    case .UnableToSetDispatchQueue:
      return "Unable to set Dispatch Queue."
      
    case .UnableToGetInitialFlags:
      return "Unable to get initial flags."
    }
  }
  
}
