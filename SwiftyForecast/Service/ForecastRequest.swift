import Foundation
import CoreLocation

struct ForecastRequest: WebService {
  private let secretKey = "6a92402c27dfc4740168ec5c0673a760"
  
  var urlRequest: URLRequest {
    return URLRequest(url: baseURL.appendingPathComponent(path))
  }

  var path: String {
    var fullPath = "forecast"
    fullPath.append("/\(secretKey)")
    fullPath.append("/\(location.coordinate.latitude),\(location.coordinate.longitude)")
    return fullPath
  }
  
  let baseURL = URL(string: "https://api.forecast.io")!
  let parameters: Parameters
  let location: CLLocation
  
  private init(parameters: Parameters, location: CLLocation) {
    self.parameters = parameters
    self.location = location
  }
}

// MARK: - Simple Factory method
extension ForecastRequest {
  
  static func make(by location: CLLocation) -> ForecastRequest {
    let defaultParameters = ["exclude": "minutely,alerts,flags", "units": "us"]
    return ForecastRequest(parameters: defaultParameters, location: location)
  }
  
}
