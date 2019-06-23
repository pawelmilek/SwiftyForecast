enum WebServiceError: ErrorHandleable {
  case unknownURL(url: String)
  case requestFailed
  case decoderFailed
  case failedToRetrieveContext
}

// MARK: - ErrorHandleable protocol
extension WebServiceError {
  
  var description: String {
    switch self {
    case .unknownURL(url: let url):
      return url
      
    case .requestFailed:
      return "An error occurred while fetching data."
      
    case .decoderFailed:
      return "An error occurred while decoding data."
      
    case .failedToRetrieveContext:
      return "Failed to retrieve context."
    }
  }
  
}
