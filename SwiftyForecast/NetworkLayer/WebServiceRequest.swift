import Foundation

final class WebServiceRequest {
  static func fetch<M: Decodable>(_ typeOf: M.Type,
                                  with request: WebService,
                                  completionHandler: @escaping (Result<M, WebServiceError>) -> ()) {
    let urlRequest = request.urlRequest
    let encodedURLRequest = urlRequest.encode(with: request.parameters)
    
    URLSession.shared.dataTask(with: encodedURLRequest) { data, response, error in
      guard let data = data, error == nil else {
        completionHandler(.failure(.requestFailed))
        return
      }
      
      completionHandler(NetworkResponseParser<M>.parseJSON(data, with: CoreDataStackHelper.shared.managedContext))
      }.resume()
  }
}
