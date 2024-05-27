//
//  NetworkResource.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 5/27/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

protocol NetworkResourceProtocol {
    func content() throws -> URL
}

struct NetworkResource: NetworkResourceProtocol {
    enum Error: Swift.Error {
        case invalidURL
    }

    private let stringURL: String

    init(stringURL: String) {
        self.stringURL = stringURL
    }

    func content() throws -> URL {
        if let privacyPolicyURL = URL(string: stringURL) {
            return privacyPolicyURL
        } else {
            throw Error.invalidURL
        }
    }
}
