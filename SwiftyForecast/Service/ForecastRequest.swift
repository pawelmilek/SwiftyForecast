import Foundation

struct ForecastRequest: WebService {
  var urlRequest: URLRequest {
    return URLRequest(url: baseURL.appendingPathComponent(path))
  }

  var path: String {
    var fullPath = NetworkConstant.path
    fullPath.append("/\(NetworkConstant.APIKey.darkSky.token)")
    fullPath.append("/\(latitude),\(longitude)")
    return fullPath
  }
  
  let baseURL = URL(string: NetworkConstant.baseURL)!
  let parameters: Parameters
  private let latitude: Double
  private let longitude: Double
  
  private init(parameters: Parameters, latitude: Double, longitude: Double) {
    self.parameters = parameters
    self.latitude = latitude
    self.longitude = longitude
  }
}

// MARK: - Simple Factory method
extension ForecastRequest {

  static func make(latitude: Double, longitude: Double) -> ForecastRequest {
    let defaultParameters = [NetworkConstant.ParameterKey.exclude: "minutely,alerts,flags",
                             NetworkConstant.ParameterKey.units: "us"]

    return ForecastRequest(parameters: defaultParameters, latitude: latitude, longitude: longitude)
  }

}
