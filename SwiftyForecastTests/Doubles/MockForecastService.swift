import Foundation
@testable import SwiftyForecast

struct MockForecastService: ForecastService {
  func getForecast(latitude: Double,
                   longitude: Double,
                   completion: @escaping (Result<ForecastResponse, WebServiceError>) -> ()) {
    
  }
  
  
}
