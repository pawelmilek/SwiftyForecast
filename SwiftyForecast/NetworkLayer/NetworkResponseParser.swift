import Foundation
import CoreData

struct NetworkResponseParser<M> where M: Decodable {
  
  static func parseJSON(_ data: Data) -> Result<M, WebServiceError> {
    do {
      let decodedModel = try JSONDecoder().decode(M.self, from: data)
      return .success(decodedModel)
      
    } catch let error {
      debugPrint(error)
      return .failure(.decoderFailed)
    }
  }
  
  static func parseJSON(_ data: Data, with context: NSManagedObjectContext) -> Result<M, WebServiceError> {
    guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
      fatalError(WebServiceError.failedToRetrieveContext.description)
    }
    
    do {
      let decoder = JSONDecoder()
      decoder.userInfo[codingUserInfoKeyManagedObjectContext] = context
      let decodedModel = try decoder.decode(M.self, from: data)
      return .success(decodedModel)
      
    } catch let error {
      debugPrint(error)
      return .failure(.decoderFailed)
    }
  }
}
