import UIKit
import CoreLocation
import Combine

extension WeatherViewController {
    @MainActor
    final class ViewModel: ObservableObject, Equatable {
        static let numberOfThreeHoursForecastItems = 8

        var compoundKey: String { locationModel?.compoundKey ?? "" }
        @Published private(set) var isLoading = false
        @Published private(set) var error: Error?
        @Published private(set) var locationName = ""
        @Published private(set) var twentyFourHoursForecastModel: [HourlyForecastModel] = []
        @Published private(set) var fiveDaysForecastModel: [DailyForecastModel] = []
        @Published private(set) var weatherModel: ForecastWeatherModel?
        @Published private(set) var locationModel: LocationModel?

        private var cancellables = Set<AnyCancellable>()

        private let service: WeatherServiceProtocol
        private let measurementSystemNotification: MeasurementSystemNotification
        private let appStoreReviewCenter: ReviewNotificationCenter

        init(
            locationModel: LocationModel,
            service: WeatherServiceProtocol = WeatherService(),
            measurementSystemNotification: MeasurementSystemNotification = MeasurementSystemNotification(),
            appStoreReviewCenter: ReviewNotificationCenter = ReviewNotificationCenter()
        ) {
            self.service = service
            self.measurementSystemNotification = measurementSystemNotification
            self.appStoreReviewCenter = appStoreReviewCenter
            subscriteToPublishers()
            addMeasurementSystemObserver()
            self.locationModel = locationModel
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
            $locationModel
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] location in
                    self?.locationName = location.name
                    self?.loadData()
                }
                .store(in: &cancellables)

            $weatherModel
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .sink { [unowned self] weatherModel in
                    setTwentyFourHoursForecastModel(weatherModel.hourly)
                    setFiveDaysForecastModel(weatherModel.daily)
                }
                .store(in: &cancellables)
        }

        func reloadCurrentLocation() {
            guard locationModel != nil else { return }
            do {
                self.locationModel = try RealmManager.shared.readAllSorted().first(where: { $0.name == locationName })
            } catch {
                fatalError(error.localizedDescription)
            }
        }

        func loadData() {
            guard let locationModel else { return }
            guard !isLoading else { return }
            isLoading = true

            let latitude = locationModel.latitude
            let longitude = locationModel.longitude

            Task(priority: .userInitiated) {
                do {
                    let forecast = try await service.fetchForecast(latitude: latitude, longitude: longitude)
                    let data = ResponseParser.parse(forecast: forecast)
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
                setFiveDaysForecastModel(daily)
            }
        }

        private func setTwentyFourHoursForecastModel(_ hourly: [HourlyForecastModel]) {
            guard hourly.count >= Self.numberOfThreeHoursForecastItems else { return }
            twentyFourHoursForecastModel = Array(hourly[...Self.numberOfThreeHoursForecastItems])
        }

        private func setFiveDaysForecastModel(_ daily: [DailyForecastModel]) {
            fiveDaysForecastModel = daily
        }

        private func postAppStoreReviewRequest() {
            appStoreReviewCenter.post(.enjoyableTemperatureReached)
        }

        static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
            lhs.locationModel?.compoundKey == rhs.locationModel?.compoundKey
        }
    }

}
