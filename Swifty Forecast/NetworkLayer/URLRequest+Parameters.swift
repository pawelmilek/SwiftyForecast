//
//  URLRequest+Parameters.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/06/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

extension URLRequest {
  
  func encode(with parameters: Parameters?) -> URLRequest {
    guard let parameters = parameters else {
      return self
    }
    
    var encodedURLRequest = self
    
    if let url = self.url, let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
      var newUrlComponents = urlComponents
      let queryItems = parameters.map { key, value in
        URLQueryItem(name: key, value: value)
      }
      
      newUrlComponents.queryItems = queryItems
      encodedURLRequest.url = newUrlComponents.url
      return encodedURLRequest
      
    } else {
      return self
    }
  }
  
}
