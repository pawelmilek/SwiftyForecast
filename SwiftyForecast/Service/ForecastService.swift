import Foundation

protocol ForecastService {
  func fetchForecast(completion: @escaping (_ error: Error?) -> ())
}
