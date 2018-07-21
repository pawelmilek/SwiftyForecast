//
//  Parser.swift
//  Swifty-Forecast
//
//  Created by Pawel Milek on 27/06/2018.
//  Copyright © 2018 Pawel Milek. All rights reserved.
//

import Foundation
import CoreData

struct Parser<M> where M: Decodable {
  
  static func parseJSON(_ data: Data) -> WebServiceResultType<M, WebServiceError> {
    do {
      let decodedModel = try JSONDecoder().decode(M.self, from: data)
      return .success(decodedModel)
      
    } catch let error {
      print(error)
      return .failure(.decodeFailed)
    }
  }
  
  static func parseJSON(_ data: Data, with context: NSManagedObjectContext) -> WebServiceResultType<M, WebServiceError> {
    guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
      fatalError(WebServiceError.failedToRetrieveContext.description)
    }
    
    do {
      let decoder = JSONDecoder()
      decoder.userInfo[codingUserInfoKeyManagedObjectContext] = context
      let decodedModel = try decoder.decode(M.self, from: data)
      return .success(decodedModel)
      
    } catch let error {
      print(error)
      return .failure(.decodeFailed)
    }
  }
  
}
