//
//  BuildConfigurationFile.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct BuildConfigurationFile {
    typealias Configurations = [String: String]

    enum Error: Swift.Error {
        case missingKey
        case invalidValue
    }

    private enum ConfigurationKey {
        static let weatherServiceAPIKey = "WeatherServiceAPIKey"
        static let supportEmailKey = "SupportEmail"
    }

    private let plistKey = "ConfigurationSettings"
    private let bundle: Bundle

    init() {
        self.init(bundle: .main)
    }

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

    func supportEmailAddress() -> String {
        do {
            return try value(with: ConfigurationKey.supportEmailKey)
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
