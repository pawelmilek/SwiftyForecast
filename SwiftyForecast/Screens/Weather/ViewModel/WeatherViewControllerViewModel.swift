import CoreLocation
import Combine
import RealmSwift

@MainActor
final class WeatherViewControllerViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published private(set) var locationName = ""
    @Published private(set) var twentyFourHoursForecastModel: [HourlyForecastModel]
    @Published private(set) var fiveDaysForecastModel: [DailyForecastModel]
    @Published private var forecastWeatherModel: ForecastModel?

    let compoundKey: String
    let latitude: Double
    let longitude: Double
    private let service: WeatherServiceProtocol
    private let metricSystemNotification: MetricSystemNotification
    private var cancellables = Set<AnyCancellable>()

    init(
        compoundKey: String,
        latitude: Double,
        longitude: Double,
        locationName: String,
        service: WeatherServiceProtocol,
        metricSystemNotification: MetricSystemNotification
    ) {
        self.compoundKey = compoundKey
        self.latitude = latitude
        self.longitude = longitude
        self.locationName = locationName
        self.service = service
        self.metricSystemNotification = metricSystemNotification
        self.twentyFourHoursForecastModel = HourlyForecastModel.initialData
        self.fiveDaysForecastModel = DailyForecastModel.initialData
        subscritePublishers()
    }

    private func subscritePublishers() {
        $forecastWeatherModel
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weatherModel in
                self?.setTwentyFourHoursForecastModel(weatherModel.hourly)
                self?.fiveDaysForecastModel = weatherModel.daily
            }
            .store(in: &cancellables)

        metricSystemNotification.publisher()
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
    }

    func loadData() async {
        defer { isLoading = false }
        isLoading = true
        do {
            forecastWeatherModel = try await service.forecast(
                latitude: latitude,
                longitude: longitude
            )
        } catch {
            forecastWeatherModel = nil
            twentyFourHoursForecastModel = []
            fiveDaysForecastModel = []
            self.error = error
            isLoading = false
        }
    }

    func reloadData() {
        if let hourly = forecastWeatherModel?.hourly,
           let daily = forecastWeatherModel?.daily {
            setTwentyFourHoursForecastModel(hourly)
            fiveDaysForecastModel = daily
        }
    }

    private func setTwentyFourHoursForecastModel(_ hourly: [HourlyForecastModel]) {
        let numberOfThreeHoursForecastItems = 7
        guard hourly.count >= numberOfThreeHoursForecastItems else { return }
        twentyFourHoursForecastModel = Array(hourly[...numberOfThreeHoursForecastItems])
    }
}
