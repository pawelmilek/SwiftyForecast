//
//  NetworkResource.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 5/27/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct NetworkResource: NetworkResourceProtocol {
    private let stringURL: String

    init(stringURL: String) {
        self.stringURL = stringURL
    }

    func contentURL() throws -> URL {
        guard let url = URL(string: stringURL) else {
            throw CocoaError(.fileReadInvalidFileName)
        }
        return url
    }
}
