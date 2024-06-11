//
//  OpenWeatherMapService.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/11/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Kingfisher
import UIKit

struct OpenWeatherMapService: WeatherService, HTTPClient {
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }

    func fetchCurrent(latitude: Double, longitude: Double) async throws -> CurrentWeatherResponse {
        return try await sendRequest(
            endpoint: WeatherEndpoint.current(latitude: latitude, longitude: longitude),
            decoder: decoder,
            responseModel: CurrentWeatherResponse.self
        )
    }

    func fetchForecast(latitude: Double, longitude: Double) async throws -> ForecastWeatherResponse {
        return try await sendRequest(
            endpoint: WeatherEndpoint.forecast(latitude: latitude, longitude: longitude),
            decoder: decoder,
            responseModel: ForecastWeatherResponse.self
        )
    }

    func fetchIcon(symbol: String) async throws -> UIImage {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<UIImage, Error>) in
            let endpoint = WeatherEndpoint.icon(symbol: symbol)
            guard let url = endpoint.url else {
                let error = RequestError.invalidURL(url: endpoint.url?.absoluteString ?? "unknown")
                continuation.resume(throwing: error)
                return
            }

            retrieveImage(withURL: url) { result in
                switch result {
                case .success(let image):
                    continuation.resume(returning: image)

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func fetchLargeIcon(symbol: String) async throws -> UIImage {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<UIImage, Error>) in
            let endpoint = WeatherEndpoint.iconLarge(symbol: symbol)

            guard let url = endpoint.url else {
                let error = RequestError.invalidURL(url: endpoint.url?.absoluteString ?? "unknown")
                continuation.resume(throwing: error)
                return
            }

            retrieveImage(withURL: url) { result in
                switch result {
                case .success(let image):
                    continuation.resume(returning: image)

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func retrieveImage(withURL url: URL, completionHandler: @escaping (Result<UIImage, Error>) -> Void) {
        let resource = KF.ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(with: resource) { result in
            switch result {
            case .success(let value):
                completionHandler(.success(value.image))

            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
