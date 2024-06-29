//
//  OpenWeatherClient.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation

struct OpenWeatherClient: HttpClient {
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }

    func requestCurrent(latitude: Double, longitude: Double) async throws -> CurrentWeatherResponse {
        return try await sendRequest(
            endpoint: OpenWeatherEndpoint.current(latitude: latitude, longitude: longitude),
            decoder: decoder,
            responseModel: CurrentWeatherResponse.self
        )
    }

    func requestForecast(latitude: Double, longitude: Double) async throws -> ForecastWeatherResponse {
        return try await sendRequest(
            endpoint: OpenWeatherEndpoint.forecast(latitude: latitude, longitude: longitude),
            decoder: decoder,
            responseModel: ForecastWeatherResponse.self
        )
    }

    func requestIcon(symbol: String) async throws -> Data {
        return try await sendRequest(
            endpoint: OpenWeatherEndpoint.icon(symbol: symbol)
        )
    }

    func requestLargeIcon(symbol: String) async throws -> Data {
        return try await sendRequest(
            endpoint: OpenWeatherEndpoint.iconLarge(symbol: symbol)
        )
    }
}

private extension OpenWeatherClient {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        decoder: JSONDecoder,
        responseModel: T.Type
    ) async throws -> T {
        do {
            let request = try request(from: endpoint)
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                throw RequestError.response
            }

            switch response.statusCode {
            case 200...226:
                return try decoder.decode(responseModel, from: data)

            case 400...451:
                throw RequestError.client(statusCode: response.statusCode)

            default:
                throw RequestError.unknown(statusCode: response.statusCode)
            }
        } catch {
            throw error
        }
    }

    func sendRequest(
        endpoint: Endpoint
    ) async throws -> Data {
        do {
            let request = try request(from: endpoint)
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                throw RequestError.response
            }

            switch response.statusCode {
            case 200...226:
                return data

            case 400...451:
                throw RequestError.client(statusCode: response.statusCode)

            default:
                throw RequestError.unknown(statusCode: response.statusCode)
            }
        } catch {
            throw error
        }
    }

    private func request(from endpoint: Endpoint) throws -> URLRequest {
        guard let url = endpoint.url else {
            throw RequestError.invalidURL(url: endpoint.url?.absoluteString ?? "unknown")
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if !endpoint.parameters.isEmpty {
            request = request.encode(with: endpoint.parameters)
        }

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        return request
    }
}
