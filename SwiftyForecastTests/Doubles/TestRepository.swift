import Foundation
@testable import SwiftyForecast

struct TestRepository: Repository {
  init(service: ForecastService, storage: ForecastDAO) {
    
  }
  
  func getForecast(latitude: Double, longitude: Double, completion: @escaping (Result<ForecastDTO?, WebServiceError>) -> ()) {
    
  }
}
