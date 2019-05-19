import Foundation
import CoreData

struct NetworkResponseParser<M> where M: Decodable {
  
  static func parseJSON(_ data: Data) -> Result<M, WebServiceError> {
    do {
      let decodedModel = try JSONDecoder().decode(M.self, from: data)
      return .success(decodedModel)
      
    } catch let error {
      print(error)
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
      print(error)
      return .failure(.decoderFailed)
    }
  }
}

// MARK: For testing
private extension NetworkResponseParser {
  
  static func printPrettyJSON(from data: Data) {
    guard let dictonary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
    guard let prettyJSON = stringify(json: dictonary) else { return }
    print(prettyJSON)
  }
  
  private static func stringify(json: [String: Any], prettyPrinted: Bool = true) -> String? {
    var options: JSONSerialization.WritingOptions = []
    
    if prettyPrinted {
      options = JSONSerialization.WritingOptions.prettyPrinted
    }
    
    do {
      let data = try JSONSerialization.data(withJSONObject: json, options: options)
      if let string = String(data: data, encoding: .utf8) {
        return string
      }
    } catch {
      print(error)
    }
    
    return nil
  }
}
