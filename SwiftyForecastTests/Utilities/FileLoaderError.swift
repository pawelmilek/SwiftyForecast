import Foundation

enum FileLoaderError: Error {
  case fileNotFound(name: String)
  case dataNotAvailable
  case unsupportedError
}



// MARK: - ErrorHandleable protocol
extension FileLoaderError {
  
  var description: String {
    switch self {
    case .fileNotFound(_):
      return "File Not Found"
      
    case .dataNotAvailable:
      return "Data Not Available"
      
    case .unsupportedError:
      return "Unsupported Error"
    }
  }
  
}
