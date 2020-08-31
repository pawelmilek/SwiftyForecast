import Foundation
import CoreLocation

protocol Repository {
  init(service: ForecastService)
  
  func getForecast(by location: CLLocation, completion: @escaping (Result<ForecastResponse, WebServiceError>) -> ()) -> Void
}
