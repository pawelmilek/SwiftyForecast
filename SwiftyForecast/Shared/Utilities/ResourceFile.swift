//
//  ResourceFile.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 5/27/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

protocol ResourceData {
    func data() throws -> Data
}

protocol ResourceURL {
    func url() throws -> URL
}

struct ResourceFile {
    enum Error: Swift.Error {
        case fileNotFound(name: String)

        var errorDescription: String? {
            switch self {
            case .fileNotFound(let name):
                return "File \(name) not found"
            }
        }
    }

    private let name: String
    private let fileExtension: String
    private let bundle: Bundle

    init(name: String, fileExtension: String, bundle: Bundle) {
        self.name = name
        self.fileExtension = fileExtension
        self.bundle = bundle
    }

    func data() throws -> Data {
        do {
            let url = try url()
            let data = try Data(contentsOf: url)
            return data
        } catch {
            throw error
        }
    }

    func url() throws -> URL {
        guard let path = bundle.url(forResource: name, withExtension: fileExtension) else {
            throw Error.fileNotFound(name: name)
        }

        return path
    }
}
