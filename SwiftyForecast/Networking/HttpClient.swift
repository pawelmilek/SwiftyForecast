import Foundation

final class HttpClient<Model: Decodable> {
  typealias Completion = ((Result<Model, WebServiceError>) -> Void)
  
  private let session: URLSession
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  func get(by request: WebService, completionHandler: @escaping Completion) {
    let urlRequest = request.urlRequest
    let encodedURLRequest = urlRequest.encode(with: request.parameters)
    
    let task = session.dataTask(with: encodedURLRequest) { data, response, error in
      guard let data = data, error == nil else {
        completionHandler(.failure(.requestFailed))
        return
      }
      
      completionHandler(NetworkResponseParser<Model>.parseJSON(data))
    }
    
    task.resume()
  }
}
