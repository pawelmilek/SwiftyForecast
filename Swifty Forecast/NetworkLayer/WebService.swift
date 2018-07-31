//
//  WebService.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 26/06/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation

final class WebService {
  static let shared = WebService()
  
  private let sessionShared: URLSession
  private lazy var baseURL: URL = {
    return URL(string: "https://api.forecast.io")!
  }()
  
  
  private init() {
    self.sessionShared = URLSession.shared
  }
}


extension WebService {
  
  func fetch<M: Decodable>(_ typeOf: M.Type, with request: WebServiceRequest, completionHandler: @escaping (WebServiceResultType<M, WebServiceError>) -> ()) {
    let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
    let encodedURLRequest = urlRequest.encode(with: request.parameters)
    
    sessionShared.dataTask(with: encodedURLRequest) { (data, _, error) in
      guard error == nil else {
        completionHandler(.failure(WebServiceError.requestFailed))
        return
      }
      
      guard let data = data else {
        completionHandler(.failure(WebServiceError.dataNotAvailable))
        return
      }
      
      completionHandler(Parser<M>.parseJSON(data, with: CoreDataStackHelper.shared.mainContext))
      }.resume()
  }
}
