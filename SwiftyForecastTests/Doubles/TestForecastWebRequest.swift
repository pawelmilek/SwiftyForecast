import Foundation
@testable import SwiftyForecast

struct TestForecastWebRequest: ForecastWebRequest {
  var urlRequest: URLRequest {
    return URLRequest(url: baseURL.appendingPathComponent(path))
  }

  var path: String {
    var fullPath = "test_forecast_path"
    fullPath.append("APIKey_token")
    fullPath.append("/\(latitude),\(longitude)")
    return fullPath
  }
  
  let baseURL = URL(string: "https://mockURL")!
  let parameters: Parameters
  var latitude = 0.0
  var longitude = 0.0
  
  init() {
    self.parameters = [:]
  }
}
