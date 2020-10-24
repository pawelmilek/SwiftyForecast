struct NetworkConstant {
  static let baseURL = "https://api.forecast.io"
  static let path = "forecast"
  
  enum APIKey {
    case darkSky
    
    var token: String {
      switch self {
      case .darkSky:
        return "6a92402c27dfc4740168ec5c0673a760"
      }
    }
  }
  
  struct ParameterKey {
    static let exclude = "exclude"
    static let units = "units"
  }

  enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
  }

  enum ContentType: String {
    case json = "application/json"
  }
}
