import Foundation

final class DefaultForecastService: ForecastService {
  
  func getForecast(by coordinate: Coordinate,
                   completionHandler: @escaping (Result<ForecastResponse, WebServiceError>) -> ()) -> () {
    let request = ForecastRequest.make(by: coordinate)
    WebServiceRequest.fetch(ForecastResponse.self, with: request, completionHandler: completionHandler)
  }
  
}
