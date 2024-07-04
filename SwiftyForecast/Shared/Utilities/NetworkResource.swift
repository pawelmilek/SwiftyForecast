//
//  NetworkResource.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 5/27/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct NetworkResource: NetworkResourceProtocol {
    enum Error: Swift.Error {
        case invalidURL
    }

    private let stringURL: String

    init(stringURL: String) {
        self.stringURL = stringURL
    }

    func contentURL() throws -> URL {
        if let url = URL(string: stringURL) {
            return url
        } else {
            throw Error.invalidURL
        }
    }
}
