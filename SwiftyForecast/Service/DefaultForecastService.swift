import Foundation
import CoreLocation

final class DefaultForecastService: ForecastService {
  
  func getForecast(by location: CLLocation,
                   completion: @escaping (Result<ForecastResponse, WebServiceError>) -> ()) -> () {
    let request = ForecastRequest.make(by: location)
    WebServiceRequest.fetch(ForecastResponse.self, with: request, completionHandler: completion)
  }
  
}
