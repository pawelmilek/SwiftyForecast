//
//  WeatherEndpoint.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

enum WeatherEndpoint: Endpoint {
    case current(latitude: Double, longitude: Double)
    case forecast(latitude: Double, longitude: Double)
    case icon(symbol: String)
    case iconLarge(symbol: String)

    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        return components.url
    }

    var scheme: String { "https" }

    var host: String {
        switch self {
        case .current, .forecast:
            return "api.openweathermap.org"

        case .icon, .iconLarge:
            return "openweathermap.org"
        }
    }

    var path: String {
        switch self {
        case .current:
            return "/data/2.5/weather"

        case .forecast:
            return "/data/2.5/forecast"

        case .icon(let symbol):
            return "/img/wn/\(symbol).png"

        case .iconLarge(let symbol):
            return "/img/wn/\(symbol)@2x.png"
        }
    }

    var parameters: Parameters {
        switch self {
        case .current(let latitude, let longitude):
            return parameterList(latitude: latitude, longitude: longitude)

        case .forecast(let latitude, let longitude):
            return parameterList(latitude: latitude, longitude: longitude)

        case .icon:
            return [:]

        case .iconLarge:
            return [:]
        }
    }

    var method: HTTPMethod { .get }
    var header: Header? { nil }
    var body: Body? { nil }

    private func parameterList(latitude: Double, longitude: Double) -> Parameters {
        let parameters = ["lat": "\(latitude)",
                          "lon": "\(longitude)",
                          "appid": Constant.apiKey,
                          "units": "standard"]
        return parameters
    }

    private enum Constant {
        static var apiKey: String = {
            do {
                let value = try ConfigurationSettingsAccessor.value(for: .apiKey)
                return value
            } catch {
                fatalError("Weather service APIKey is unavailable. Please, check configuration settings file.")
            }
        }()
    }
}
