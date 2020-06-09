import Foundation

extension URLRequest {
  
  func encode(with parameters: Parameters?) -> URLRequest {
    guard let parameters = parameters, !parameters.isEmpty else { return self }
    
    if let URL = url, var components = URLComponents(url: URL, resolvingAgainstBaseURL: false) {
      let queryItems = parameters.map { key, value in
        URLQueryItem(name: key, value: value)
      }
      
      var encodedURLRequest = self
      components.queryItems = queryItems
      encodedURLRequest.url = components.url
      return encodedURLRequest
      
    } else {
      return self
    }
  }
  
}
