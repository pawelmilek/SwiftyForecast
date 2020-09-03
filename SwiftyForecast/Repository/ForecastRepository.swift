import Foundation
import RealmSwift
import CoreLocation

struct ForecastRepository: Repository {
  private let service: ForecastService
  private var storage: DataStorage
  
  init(service: ForecastService, storage: DataStorage = ForecastDataStorage()) {
    self.service = service
    self.storage = storage
  }
  
  func getForecast(latitude: Double,
                   longitude: Double,
                   completion: @escaping (Result<ForecastDTO, WebServiceError>) -> ()) {
    if RateLimiter.canFetch(interval: 1000) {
      let data = storage.get(latitude: latitude, longitude: longitude)
      if let forecastDTO = ModelTranslator().translate(forecast: data) {
        completion(.success(forecastDTO))
        
      } else {
        completion(.failure(.requestFailed))
      }
    } else {
      refreshForecastData(latitude: latitude, longitude: latitude) { result in
        switch result {
        case .success(let data):
          self.storage.put(data: data)
          
          if let forecastDTO = ModelTranslator().translate(forecast: data) {
            completion(.success(forecastDTO))
            
          } else {
            completion(.failure(.requestFailed))
          }
          
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

