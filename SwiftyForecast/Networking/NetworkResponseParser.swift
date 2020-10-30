import Foundation

struct NetworkResponseParser<M> where M: Decodable {
  
  static func parseJSON(_ data: Data) -> Result<M, WebServiceError> {
    do {
      let decodedModel = try JSONDecoder().decode(M.self, from: data)
      return .success(decodedModel)
      
    } catch let error {
      debugPrint("File: \(#file), Function: \(#function), line: \(#line) \(error)")
      return .failure(.decoderFailed)
    }
  }
  
}
