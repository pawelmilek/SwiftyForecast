protocol ForecastService {
  init(httpClient: HttpClient<ForecastResponse>, request: ForecastWebRequest)
  
  func getForecast(latitude: Double,
                   longitude: Double,
                   completion: @escaping (Result<ForecastResponse, WebServiceError>) -> ()) -> Void
}
