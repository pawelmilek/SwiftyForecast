protocol DataStorage {
  func get(latitude: Double, longitude: Double) -> ForecastResponse?
  func put(data: ForecastResponse)
}
