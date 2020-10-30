import Foundation
@testable import SwiftyForecast

struct TestRepository: Repository {
  private let service: ForecastService
  private let dataAccessObject: ForecastDAO
  
  init(service: ForecastService, dataAccessObject: ForecastDAO) {
    self.service = service
    self.dataAccessObject = dataAccessObject
  }
  
  func getForecast(latitude: Double, longitude: Double, completion: @escaping (Result<ForecastDTO?, WebServiceError>) -> ()) {
    
    service.getForecast(latitude: latitude, longitude: longitude) { result in
      if case let Result.success(data) = result {
        let testForecastDTO = ModelTranslator().translate(forecast: data)!
        completion(.success(testForecastDTO))
      }
    }
  }
}
