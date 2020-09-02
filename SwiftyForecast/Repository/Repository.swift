import Foundation
import CoreLocation

protocol Repository {
  init(service: ForecastService, forecastDAO: ForecastDAO)
  
  func getForecast(by location: CLLocation, completion: @escaping (Result<ForecastResponse, WebServiceError>) -> ()) -> Void
}
