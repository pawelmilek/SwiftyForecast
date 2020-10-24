import Foundation

struct DefaultForecastWebRequest: ForecastWebRequest {
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
  var latitude = 0.0
  var longitude = 0.0
  
  init() {
    self.parameters = [NetworkConstant.ParameterKey.exclude: "minutely,alerts,flags",
                       NetworkConstant.ParameterKey.units: "us"]
  }
}
