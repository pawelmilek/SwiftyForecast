protocol ForecastDAO {
  func get(latitude: Double, longitude: Double) -> ForecastResponse?
  func put(_ forecast: ForecastResponse)
  func delete(_ forecast: ForecastResponse) throws
  func deleteAll() throws
}
