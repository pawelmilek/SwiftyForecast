import Foundation
import CoreLocation

final class CurrentWeatherViewModel: ContentViewModelProtocol {
    var hourly: HourlyForecastModel? {
        return forecast?.hourly
    }

    var symbol: String {
        guard let icon = forecast?.current.icon else { return "cloud.rainbow.half" }
        return "cloud.rainbow.half"
    }

    var weekdayMonthDay: String {
        guard let date = forecast?.current.date else { return InvalidReference.notApplicable }
        let formatter = DateFormatter()

        formatter.dateFormat = "MMMM d"
        let longDayMonth = formatter.string(from: date)

        formatter.dateFormat = "EEEE"
        let weekday = formatter.string(from: date)

        return "\(weekday), \(longDayMonth)".uppercased()
    }

    var cityName: String {
        return city.name
    }

    var temperature: String {
        guard let currently = forecast?.current else { return InvalidReference.notApplicable }
        switch NotationController().temperatureNotation {
        case .celsius:
            let temperatureInCelsius = currently.temperature.ToCelsius()
            return temperatureInCelsius.roundedToString + Style.degreeSign

        case .fahrenheit:
            let temperatureInFahrenheit = currently.temperature.ToFahrenheit()
            postAppStoreReviewRequest(enjoyableTemperature: temperatureInFahrenheit)
            return temperatureInFahrenheit.roundedToString + Style.degreeSign
        }
    }

    var humidity: String {
        guard let current = forecast?.current else { return InvalidReference.notApplicable }
        return "\(Int(current.humidity * 100))"
    }

    var sunriseTime: String {
        //    guard let sunriseTime = forecast?.daily.currentDayData.sunriseTime else {
        //        return InvalidReference.notApplicable
        //    }
        return "sunriseTime.getTime()"
    }

    var sunsetTime: String {
        //    guard let sunsetTime = forecast?.daily.currentDayData.sunsetTime else {
        //        return InvalidReference.notApplicable
        //    }
        return "sunsetTime.getTime()"
    }

    var windSpeed: String {
        let speed = forecast?.current.windSpeed ?? 0
        switch NotationController().unitNotation {
        case .imperial:
            return String(format: "%.f MPH", speed)

        case .metric:
            return String(format: "%.f KPH", speed.toKPH())
        }
    }

    var numberOfDays: Int {
        return forecast?.daily.numberOfDays ?? 0
    }

    var sevenDaysData: [DailyDataModel] {
        return forecast?.daily.data ?? []
    }

    var location: LocationModel {
        return LocationModel(latitude: city.latitude, longitude: city.longitude)
    }

    var onSuccess: (() -> Void)?
    var onFailure: ((Error) -> Void)?
    var onLoadingStatus: ((Bool) -> Void)?
    var pageIndex = 0

    private var isLoadingData = false {
        didSet {
            onLoadingStatus?(isLoadingData)
        }
    }

    private let city: CityModel
    private let repository: Repository
    private var forecast: WeatherModel?

    init(city: CityModel, repository: Repository) {
        self.city = city
        self.repository = repository
    }
}

// MARK: - Fetch Forecast Data
extension CurrentWeatherViewModel {

    func loadData() {
        guard !isLoadingData else { return }

        isLoadingData.toggle()

        Task(priority: .userInitiated) {
            do {
                let data = try await repository.fetch(
                    latitude: location.latitude,
                    longitude: location.longitude
                )

                isLoadingData.toggle()
                forecast = data
                onSuccess?()
            } catch {
                isLoadingData.toggle()
                forecast = nil
                onFailure?(error)
            }
        }
    }

}

// MARK: - Private - Post App Store Review request
private extension CurrentWeatherViewModel {

    private func postAppStoreReviewRequest(enjoyableTemperature: Double) {
        let roundedValue = Int(enjoyableTemperature)
        AppStoreReviewNotifier.notify(.enjoyableOutsideTemperatureReached(value: roundedValue))
    }

}
