import Foundation
import CoreLocation

final class DefaultForecastService: ForecastService {
  private let httpClient: HttpClient<ForecastResponse>
  private var request: ForecastWebService
  
  init(httpClient: HttpClient<ForecastResponse>, request: ForecastWebService) {
    self.httpClient = httpClient
    self.request = request
  }
  
  func getForecast(latitude: Double,
                   longitude: Double,
                   completion: @escaping (Result<ForecastResponse, WebServiceError>) -> ()) -> () {
    request.latitude = latitude
    request.longitude = longitude
    
    httpClient.get(by: request, completionHandler: completion)
  }

}
