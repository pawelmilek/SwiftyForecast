protocol Repository {
  init(service: ForecastService, storage: DataStorage)
  
  func getForecast(latitude: Double,
                   longitude: Double,
                   completion: @escaping (Result<ForecastDTO, WebServiceError>) -> ()) -> Void
}
