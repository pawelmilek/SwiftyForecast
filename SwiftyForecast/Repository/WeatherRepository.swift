import RealmSwift
import UIKit

struct WeatherRepository: Repository {
    private let service: WeatherServiceProtocol

    init(service: WeatherServiceProtocol) {
        self.service = service
    }

    func fetch(latitude: Double, longitude: Double) async throws -> WeatherModel {
        async let current = service.fetchCurrent(latitude: latitude, longitude: longitude)
        async let forecast = service.fetchForecast(latitude: latitude, longitude: longitude)
        let response = try await (current: current, forecast: forecast)

        let forecastDTO = ResponseParser.parse(response)
        return forecastDTO
    }

    func fetchIcon(_ iconCode: String) async throws -> UIImage {
        try await service.fetchIcon(symbol: iconCode)
    }

    func fetchLargeIcon(_ iconCode: String) async throws -> UIImage {
        try await service.fetchLargeIcon(symbol: iconCode)
    }

    //    func getForecast(latitude: Double,
    //                     longitude: Double,
    //                     completion: @escaping (Result<ForecastDTO?, RequestError>) -> ()) {
    //        if let data = dataAccessObject.get(latitude: latitude, longitude: longitude),
    //    !RateLimiter.shouldFetch(by: data.lastUpdate) {
    //            let forecastDTO = ModelTranslator().translate(forecast: data)
    //            completion(.success(forecastDTO))
    //
    //        } else {
    //            Task(priority: .userInitiated) {
    //                let result = try await service.fetchForecast(latitude: latitude, longitude: longitude)
    //                switch result {
    //                case .success(let data):
    //                    self.dataAccessObject.put(data)
    //                    let forecastDTO = ModelTranslator().translate(forecast: data)
    //                    completion(.success(forecastDTO))
    //
    //                case .failure(let error):
    //                    completion(.failure(error))
    //                }
    //            }
    //        }
    //    }

}
