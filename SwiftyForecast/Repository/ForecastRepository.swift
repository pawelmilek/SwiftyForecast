import Foundation
import CoreLocation

struct ForecastRepository: Repository {
  private let service: ForecastService
  
  init(service: ForecastService) {
    self.service = service
  }
  
  func getForecast(by location: CLLocation, completion: @escaping (Result<ForecastResponse, WebServiceError>) -> ()) -> Void {
    service.getForecast(by: location, completion: completion)
  }
}
