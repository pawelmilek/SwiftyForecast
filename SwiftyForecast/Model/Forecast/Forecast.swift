import Foundation

protocol Forecast {
  var date: ForecastDate { get }
  var summary: String { get }
  var icon: String { get }
  var precipIntensity: Double { get }
  var precipProbability: Double { get }
  var temperature: Double { get }
  var apparentTemperature: Double { get }
  var dewPoint: Double { get }
  var humidity: Double { get }
  var pressure: Double { get }
  var windSpeed: Double { get }
  var windGust: Double { get }
  var windBearing: Double { get }
  var cloudCover: Double { get }
  var uvIndex: Int { get }
  var visibility: Double { get }
  var ozone: Double { get }
}
