//
//  PathError.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

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

        case .containerNotFound(let identifier):
            return "Shared container for group \(identifier) not found"
        }
    }

}
