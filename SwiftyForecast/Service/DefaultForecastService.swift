import Foundation
import CoreLocation

final class DefaultForecastService: ForecastService {

  func getForecast(latitude: Double,
                   longitude: Double,
                   completion: @escaping (Result<ForecastResponse, WebServiceError>) -> ()) -> () {
    let request = ForecastRequest.make(latitude: latitude, longitude: longitude)
    WebServiceRequest.fetch(ForecastResponse.self, with: request, completionHandler: completion)
  }

}
