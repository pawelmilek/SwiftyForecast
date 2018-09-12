//
//  WebService.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 26/06/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

final class WebService {
  static let shared = WebService()
  
  private let sessionShared: URLSession
  
  private init() {
    self.sessionShared = URLSession.shared
  }
}


// MARK: - Fetch data
extension WebService {
  
  func fetch<M: Decodable>(_ typeOf: M.Type, with request: WebServiceRequest, completionHandler: @escaping (ResultType<M, WebServiceError>) -> ()) {
    let urlRequest = request.urlRequest
    let encodedURLRequest = urlRequest.encode(with: request.parameters)
    
    sessionShared.dataTask(with: encodedURLRequest) { (data, _, error) in
      guard error == nil else {
        completionHandler(.failure(.requestFailed))
        return
      }
      
      guard let data = data else {
        completionHandler(.failure(.dataNotAvailable))
        return
      }
      
      completionHandler(Parser<M>.parseJSON(data, with: CoreDataStackHelper.shared.mainContext))
      }.resume()
  }
  
}
