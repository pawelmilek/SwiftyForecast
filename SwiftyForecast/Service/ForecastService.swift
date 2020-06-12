import CoreLocation

protocol ForecastService {
  func getForecast(by location: CLLocation, completion: @escaping (Result<ForecastResponse, WebServiceError>) -> ()) -> Void
}
