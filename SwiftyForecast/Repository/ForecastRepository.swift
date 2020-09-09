import Foundation
import RealmSwift
import CoreLocation

struct ForecastRepository: Repository {
  private let service: ForecastService
  private var forecastDAO: ForecastDAO
  
  init(service: ForecastService, storage: ForecastDAO = DefaultForecastDAO()) {
    self.service = service
    self.forecastDAO = storage
  }
  
  func getForecast(latitude: Double,
                   longitude: Double,
                   completion: @escaping (Result<ForecastDTO?, WebServiceError>) -> ()) {
    if let data = forecastDAO.get(latitude: latitude, longitude: longitude), !RateLimiter.shouldFetch(by: data.lastUpdate) {
      let forecastDTO = ModelTranslator().translate(forecast: data)
      completion(.success(forecastDTO))
      
    } else {
      refreshForecastData(latitude: latitude, longitude: longitude) { result in
        switch result {
        case .success(let data):
          self.forecastDAO.put(data)
          let forecastDTO = ModelTranslator().translate(forecast: data)
          completion(.success(forecastDTO))

        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
  }
  
  private func refreshForecastData(latitude: Double,
                                   longitude: Double,
                                   completion: @escaping (Result<ForecastResponse, WebServiceError>) -> ()) {
    service.getForecast(latitude: latitude, longitude: longitude) { result in
      switch result {
      case .success(let data):
        completion(.success(data))
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

