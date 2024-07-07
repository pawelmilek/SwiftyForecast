//
//  FileBuildConfiguration.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

protocol BuildConfiguration {
    func weatherServiceAPIKey() -> String
}

struct FileBuildConfiguration: BuildConfiguration {
    typealias Configurations = [String: String]

    enum Error: Swift.Error {
        case missingKey
        case invalidValue
    }

    private enum ConfigurationKey {
        static let weatherServiceAPIKey = "WeatherServiceAPIKey"
    }

    private let plistKey = "ConfigurationSettings"
    private let bundle: Bundle

    init(bundle: Bundle) {
        self.bundle = bundle
    }

    func weatherServiceAPIKey() -> String {
        do {
            return try value(with: ConfigurationKey.weatherServiceAPIKey)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func value(with key: String) throws -> String {
        guard let content = bundle.object(forInfoDictionaryKey: plistKey) as? Configurations else {
            throw Error.missingKey
        }
        guard let value = content[key] else { throw Error.invalidValue }
        return value
    }
}
