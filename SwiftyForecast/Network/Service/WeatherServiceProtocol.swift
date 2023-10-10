import UIKit

protocol WeatherServiceProtocol {
    func fetchCurrent(
        latitude: Double,
        longitude: Double
    ) async throws -> CurrentWeatherResponse

    func fetchForecast(
        latitude: Double,
        longitude: Double
    ) async throws -> ForecastWeatherResponse

    func fetchIcon(symbol: String) async throws -> UIImage
    func fetchLargeIcon(symbol: String) async throws -> UIImage
}
