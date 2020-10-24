import Foundation

enum PathError: Error {
  case notFound
  case containerNotFound(identifier: String)
}

// MARK: - LocalizedError protocol
extension PathError: LocalizedError {

  var errorDescription: String? {
    switch self {
    case .notFound:
      return "Resource not found"
      
    case .containerNotFound(let id):
      return "Shared container for group \(id) not found"
    }
  }

}
