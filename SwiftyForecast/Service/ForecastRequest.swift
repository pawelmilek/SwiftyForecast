import Foundation
import CoreLocation

struct ForecastRequest: WebService {
  private let secretKey = "6a92402c27dfc4740168ec5c0673a760"
  
  let parameters: Parameters
  let baseURL = URL(string: "https://api.forecast.io")!
  var path = "forecast"
  let urlRequest: URLRequest
  
  private init(parameters: Parameters, location: CLLocation) {
    self.parameters = parameters
    self.path.append("/\(secretKey)")
    self.path.append("/\(location.coordinate.latitude),\(location.coordinate.longitude)")
    self.urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
  }
}

// MARK: - Simple Factory method
extension ForecastRequest {
  
  static func make(by location: CLLocation) -> ForecastRequest {
    let defaultParameters = ["exclude": "minutely,alerts,flags", "units": "us"]
    return ForecastRequest(parameters: defaultParameters, location: location)
  }

}
