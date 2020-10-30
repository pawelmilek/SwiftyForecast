enum FileLoaderError: ErrorHandleable {
  case fileNotFound(name: String)
  case incorrectFormat
  case unsupportedError
}

// MARK: - ErrorHandleable protocol
extension FileLoaderError {
  
  var description: String {
    switch self {
    case .fileNotFound(_):
      return "File Not Found"

    case .incorrectFormat:
      return "Error reading unrecognized format"
      
    case .unsupportedError:
      return "Unsupported Error"
    }
  }
  
}
