import Foundation
@testable import SwiftyForecast

final class TestForecastService: ForecastService {
  var successCompletion: (Result<ForecastResponse, WebServiceError>)!

  init(httpClient: HttpClient<ForecastResponse>, request: ForecastWebRequest) { }
  
  func getForecast(latitude: Double,
                   longitude: Double,
                   completion: @escaping (Result<ForecastResponse, WebServiceError>) -> ()) {
    completion(successCompletion)
  }
}
