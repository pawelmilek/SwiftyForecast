//
//  ForecastRequest.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/06/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

struct ForecastRequest: WebServiceRequest {
  private let secretKey = "6a92402c27dfc4740168ec5c0673a760"
  
  var path = "forecast"
  var parameters: Parameters
  var coordinate: Coordinate
  
  private init(parameters: Parameters, coordinate: Coordinate) {
    self.parameters = parameters
    self.coordinate = coordinate
    self.path.append("/\(secretKey)")
    self.path.append("/\(coordinate.latitude),\(coordinate.longitude)")
  }
}


// MARK: - Factory method
extension ForecastRequest {
  
  static func make(by coordinate: Coordinate) -> ForecastRequest {
    let defaultParameters = ["exclude": "minutely,alerts,flags", "units": "us"]
    return ForecastRequest(parameters: defaultParameters, coordinate: coordinate)
  }

}
