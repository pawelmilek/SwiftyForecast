import Foundation

struct CurrentWeatherModel {
    let date: Date
    let dayNightState: DayNightState
    let temperature: Double
    let maxTemperature: Double
    let minTemperature: Double
    let description: String
    let icon: String
    let humidity: Int
    let pressure: Int
    let windSpeed: Double
    let sunrise: Date
    let sunset: Date
}
