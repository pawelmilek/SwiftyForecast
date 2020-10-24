protocol Repository {
  init(service: ForecastService, dataAccessObject: ForecastDAO)
  
  func getForecast(latitude: Double,
                   longitude: Double,
                   completion: @escaping (Result<ForecastDTO?, WebServiceError>) -> ()) -> Void
}
