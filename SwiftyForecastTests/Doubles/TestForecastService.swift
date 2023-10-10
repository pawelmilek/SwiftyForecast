import Foundation
@testable import SwiftyForecast

final class TestForecastService: WeatherService {
    var successCompletion: (Result<ForecastResponse, RequestError>)!

    init(httpClient: HttpClient<ForecastResponse>, request: ForecastWebRequest) { }

    func getForecast(latitude: Double,
                     longitude: Double,
                     completion: @escaping (Result<ForecastResponse, RequestError>) -> Void) {
        completion(successCompletion)
    }
}
