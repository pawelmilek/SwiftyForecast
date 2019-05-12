protocol Forecast {
  var date: ForecastDate { get }
  var summary: String { get }
  var icon: String { get }
  var temperature: Double { get }
  var apparentTemperature: Double { get }
  var humidity: Double { get }
  var pressure: Double { get }
  var windSpeed: Double { get }
  var uvIndex: Int { get }
}
