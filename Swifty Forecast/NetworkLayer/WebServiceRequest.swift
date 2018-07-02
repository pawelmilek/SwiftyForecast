//
//  WebServiceRequest.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 27/06/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

typealias Parameters = [String: String]

protocol WebServiceRequest {
  var path: String { get }
  var parameters: Parameters { get }
}
