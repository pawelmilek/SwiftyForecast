import Foundation

enum WebServiceError: ErrorHandleable {
  case unknownURL(url: String)
  case requestFailed
  case dataNotAvailable
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
      return "An error occurred while fetching JSON data."
      
    case .dataNotAvailable:
      return "Data not available."
      
    case .decoderFailed:
      return "An error occurred while decoding data."
      
    case .failedToRetrieveContext:
      return "Failed to retrieve context."
    }
  }
  
}
