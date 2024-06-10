//
//  FileLoaderError.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

enum FileLoaderError: LocalizedError {
  case fileNotFound(name: String)
}

// MARK: - Error description
extension FileLoaderError {

  var errorDescription: String? {
    switch self {
    case .fileNotFound:
      return "File Not Found"
    }
  }

}
