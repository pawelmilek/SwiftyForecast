enum FileLoaderError: ErrorPresentable {
  case fileNotFound(name: String)
  case incorrectFormat
  case unsupportedError
}

// MARK: - ErrorHandleable protocol
extension FileLoaderError {

  var errorDescription: String? {
    switch self {
    case .fileNotFound:
      return "File Not Found"

    case .incorrectFormat:
      return "Error reading unrecognized format"

    case .unsupportedError:
      return "Unsupported Error"
    }
  }

}
