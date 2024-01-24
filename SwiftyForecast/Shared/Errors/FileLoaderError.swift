//
//  FileLoaderError.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

enum FileLoaderError: Error {
  case fileNotFound(name: String)
  case incorrectFormat
  case unsupportedError
}

// MARK: - Error description
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
