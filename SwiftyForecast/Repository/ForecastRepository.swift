import Foundation
import RealmSwift
import CoreLocation

struct ForecastRepository: Repository {
  private let service: ForecastService
  private var forecastDAO: ForecastDAO
  
  init(service: ForecastService, forecastDAO: ForecastDAO = ForecastDAO()) {
    self.service = service
    self.forecastDAO = forecastDAO
  }
  
  func getForecast(by location: CLLocation, completion: @escaping (Result<ForecastResponse, WebServiceError>) -> ()) {
    if forecastDAO.hasValidData(interval: 1000),
      let data = forecastDAO.get(for: location) { // RateLimiter.canFetch()
      completion(.success(data))

    } else {
      refreshForecastData(by: location) { result in
        switch result {
        case .success(let data):
//          let freshData = self.forecastDAO.get(for: location)
//          
//          let dataRef = ThreadSafeReference(to: data)
//          DispatchQueue(label: "com.example.myApp.bg").async {
//            let realm = RealmProvider.core.realm
//            guard let forecastResponse = realm.resolve(dataRef) else { return }
//            
//            self.forecastDAO.put(data: forecastResponse)
//            
//          }
          
        completion(.success(data))
          
          
        case .failure(let error):
          completion(.failure(error))
        }
        
      }
    }
  }
  
  private func refreshForecastData(by location: CLLocation, completion: @escaping (Result<ForecastResponse, WebServiceError>) -> ()) {
    service.getForecast(by: location) { result in
      switch result {
      case .success(let data):
        completion(.success(data))
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}


struct RateLimiter {
  private static let freshTimeoutInterval: TimeInterval = 1000
  
  func canFetch() {
    
  }
}
