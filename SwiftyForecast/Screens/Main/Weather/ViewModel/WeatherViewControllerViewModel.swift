import UIKit
import CoreLocation
import Combine

@MainActor
final class WeatherViewControllerViewModel: ObservableObject {
    static let numberOfThreeHoursForecastItems = 7

    var compoundKey: String { locationModel.compoundKey }
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published private(set) var locationName = ""
    @Published private(set) var twentyFourHoursForecastModel: [HourlyForecastModel] = []
    @Published private(set) var fiveDaysForecastModel: [DailyForecastModel] = []
    @Published private(set) var weatherModel: ForecastWeatherModel?

    private var cancellables = Set<AnyCancellable>()
    var locationModel: LocationModel
    private let client: WeatherClient
    private let measurementSystemNotification: MeasurementSystemNotification
    private let appStoreReviewCenter: ReviewNotificationCenter

    init(
        locationModel: LocationModel,
        client: WeatherClient,
        measurementSystemNotification: MeasurementSystemNotification,
        appStoreReviewCenter: ReviewNotificationCenter
    ) {
        self.locationModel = locationModel
        self.client = client
        self.measurementSystemNotification = measurementSystemNotification
        self.appStoreReviewCenter = appStoreReviewCenter
        self.locationName = locationModel.name
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
//        $locationModel
//            .compactMap { $0 }
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] location in
//                self?.locationName = location.name
//                self?.loadData()
//            }
//            .store(in: &cancellables)

        $weatherModel
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] weatherModel in
                setTwentyFourHoursForecastModel(weatherModel.hourly)
                fiveDaysForecastModel = weatherModel.daily
            }
            .store(in: &cancellables)
    }

    func reloadCurrentLocation() {
        if let location = try? RealmManager.shared.readAllSorted().first(where: { $0.name == locationName }) {
            locationModel = location
            loadData()
        } else {
            fatalError()
        }
    }

    func loadData() {
        guard !isLoading else { return }
        isLoading = true

        Task(priority: .userInitiated) {
            do {
                let forecast = try await client.fetchForecast(
                    latitude: locationModel.latitude,
                    longitude: locationModel.longitude
                )
                let data = ResponseParser().parse(forecast: forecast)
                weatherModel = data
                isLoading = false

            } catch {
                weatherModel = nil
                twentyFourHoursForecastModel = []
                fiveDaysForecastModel = []
                self.error = error
                isLoading = false
            }
        }
    }

    func reloadData() {
        if let hourly = weatherModel?.hourly,
           let daily = weatherModel?.daily {
            setTwentyFourHoursForecastModel(hourly)
            fiveDaysForecastModel = daily
        }
    }

    private func setTwentyFourHoursForecastModel(_ hourly: [HourlyForecastModel]) {
        guard hourly.count >= Self.numberOfThreeHoursForecastItems else { return }
        twentyFourHoursForecastModel = Array(hourly[...Self.numberOfThreeHoursForecastItems])
    }

    private func postAppStoreReviewRequest() {
        appStoreReviewCenter.post(.enjoyableTemperatureReached)
    }
}
