import Foundation
import CoreLocation

struct ForecastRequest: WebService {
  var urlRequest: URLRequest {
    return URLRequest(url: baseURL.appendingPathComponent(path))
  }

  var path: String {
    var fullPath = NetworkConstant.path
    fullPath.append("/\(NetworkConstant.APIKey.darkSky.token)")
    fullPath.append("/\(location.coordinate.latitude),\(location.coordinate.longitude)")
    return fullPath
  }
  
  let baseURL = URL(string: NetworkConstant.baseURL)!
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
    let defaultParameters = [NetworkConstant.ParameterKey.exclude: "minutely,alerts,flags",
                             NetworkConstant.ParameterKey.units: "us"]
    return ForecastRequest(parameters: defaultParameters, location: location)
  }
  
}
