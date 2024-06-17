import UIKit
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
    @Published private(set) var forecastWeatherModel: ForecastWeatherModel?

    private var cancellables = Set<AnyCancellable>()
    let compoundKey: String
    let latitude: Double
    let longitude: Double
    private let client: WeatherClient
    private let parser: ResponseParser
    private let measurementSystemNotification: MeasurementSystemNotification
    private let appStoreReviewCenter: ReviewNotificationCenter

    init(
        compoundKey: String,
        latitude: Double,
        longitude: Double,
        locationName: String,
        client: WeatherClient,
        parser: ResponseParser,
        measurementSystemNotification: MeasurementSystemNotification,
        appStoreReviewCenter: ReviewNotificationCenter
    ) {
        self.compoundKey = compoundKey
        self.latitude = latitude
        self.longitude = longitude
        self.locationName = locationName
        self.client = client
        self.parser = parser
        self.measurementSystemNotification = measurementSystemNotification
        self.appStoreReviewCenter = appStoreReviewCenter
        self.twentyFourHoursForecastModel = HourlyForecastModel.initialData
        self.fiveDaysForecastModel = DailyForecastModel.initialData
        subscriteToPublishers()
        addMeasurementSystemObserver()

    }

    private func addMeasurementSystemObserver() {
        measurementSystemNotification.addObserver(
            self,
            selector: #selector(measurementSystemChanged)
        )
    }

    @objc
    private func measurementSystemChanged() {
        reloadData()
    }

    private func subscriteToPublishers() {
        $forecastWeatherModel
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] weatherModel in
                setTwentyFourHoursForecastModel(weatherModel.hourly)
                fiveDaysForecastModel = weatherModel.daily
            }
            .store(in: &cancellables)
    }

    func loadData() async {
        defer { isLoading = false }
        isLoading = true
        do {
            let forecast = try await client.fetchForecast(
                latitude: latitude,
                longitude: longitude
            )
            let data = parser.parse(forecast: forecast)
            forecastWeatherModel = data
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

    private func postAppStoreReviewRequest() {
        appStoreReviewCenter.post(.enjoyableTemperatureReached)
    }
}
