import Foundation

protocol ForecastService {
  func getForecast(by coordinate: Coordinate,
                   completionHandler: @escaping (Result<ForecastResponse, WebServiceError>) -> ()) -> Void
}
