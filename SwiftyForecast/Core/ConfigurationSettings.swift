//
//  ConfigurationSettings.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct ConfigurationSettings {
    enum Key: String {
        case apiKey = "WeatherServiceApiKey"
    }

    private static let configurationKey = "ConfigurationSettings"
    private static let bundle = Bundle.main

    private init() { }

    static func value(for key: Key) throws -> String {
        guard let configDictionary = bundle.object(
            forInfoDictionaryKey: configurationKey
        ) as? [String: String] else {
            throw CocoaError(.keyValueValidation)
        }

        if let value = configDictionary[key.rawValue] {
            return value
        } else {
            throw CocoaError(.keyValueValidation)
        }
    }
}
