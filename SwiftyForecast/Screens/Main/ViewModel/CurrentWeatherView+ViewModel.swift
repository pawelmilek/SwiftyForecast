import UIKit
import CoreLocation

extension CurrentWeatherView {

    @MainActor
    final class ViewModel: ObservableObject, Equatable {
        private static let numberOfThreeHoursForecastItems = 8

        @Published var weekdayMonthDay = ""
        @Published var locationName = ""
        @Published var icon: UIImage?
        @Published var description = ""
        @Published var dayNight = ""
        @Published var temperature = ""
        @Published var temperatureMaxMin = ""
        @Published var sunriseTime = ""
        @Published var sunsetTime = ""
        @Published var windSpeed = ""
        @Published var humidity = ""
        @Published var windSpeedSymbol = ""
        @Published var humiditySymbol = ""
        @Published var sunriseSymbol = ""
        @Published var sunsetSymbol = ""
        @Published var isLoading = false
        @Published var error: Error?
        @Published var isTwentyFourHoursForecastLoaded = false
        @Published var isFiveDaysForecastLoaded = false
        @Published var measurementSystem: MeasurementSystem
        @Published var temperatureNotation: TemperatureNotation

        private let locationModel: LocationModel
        private let repository: Repository
        private let temperatureVolumeFactory: TemperatureVolumeFactoryProtocol
        private let speedVolumeFactory: SpeedVolumeFactoryProtocol
        private let notationController: NotationController
        private let appStoreReviewCenter: AppStoreReviewCenter
        private var weatherModel: WeatherModel?
        private(set) var twentyFourHoursForecastModel: [HourlyForecastModel] = []
        private(set) var fiveDaysForecastModel: [DailyForecastModel] = []

        init(
            locationModel: LocationModel,
            repository: Repository,
            temperatureVolumeFactory: TemperatureVolumeFactoryProtocol = TemperatureVolumeFactory(),
            speedVolumeFactory: SpeedVolumeFactoryProtocol = SpeedVolumeFactory(),
            notationController: NotationController = NotationController(),
            appStoreReviewCenter: AppStoreReviewCenter = AppStoreReviewCenter()
        ) {
            self.locationModel = locationModel
            self.repository = repository
            self.temperatureVolumeFactory = temperatureVolumeFactory
            self.speedVolumeFactory = speedVolumeFactory
            self.notationController = notationController
            self.appStoreReviewCenter = appStoreReviewCenter
            self.measurementSystem = notationController.measurementSystem
            self.temperatureNotation = notationController.temperatureNotation
        }

        func loadData() {
            guard !isLoading else { return }
            isLoading.toggle()

            Task(priority: .userInitiated) {
                do {
                    let location = CLLocationCoordinate2D(
                        latitude: locationModel.latitude,
                        longitude: locationModel.longitude
                    )
                    let data = try await repository.fetch(
                        latitude: location.latitude,
                        longitude: location.longitude
                    )
                    let largeIcon = try await repository.fetchLargeIcon(
                        data.current.icon
                    )

                    icon = largeIcon
                    weatherModel = data
                    setTwentyFourHoursForecastModel()
                    setFiveDaysForecastModel()
                    setPublishers()
                    isLoading.toggle()

                } catch {
                    icon = nil
                    weatherModel = nil
                    twentyFourHoursForecastModel = []
                    fiveDaysForecastModel = []
                    self.error = error
                    isLoading.toggle()
                }
            }
        }

        func reloadData() {
            setTemperatureAccordingToUnitNotation()
            setWindSpeedAccordingToMeasurementSystem()
            isTwentyFourHoursForecastLoaded = true
            isFiveDaysForecastLoaded = true
        }

        func onSegmentedControlChange(_ sender: SegmentedControl) {
            guard let measurementSystem = MeasurementSystem(rawValue: sender.selectedIndex),
                  let temperatureNotation = TemperatureNotation(rawValue: sender.selectedIndex) else {
                return
            }

            notationController.measurementSystem = measurementSystem
            notationController.temperatureNotation = temperatureNotation
            self.measurementSystem = measurementSystem
            self.temperatureNotation = temperatureNotation
        }

        private func setPublishers() {
            guard let current = weatherModel?.current else { return }

            locationName = locationModel.name
            weekdayMonthDay = current.date.weekdayMonthDay
            description = current.description
            dayNight = current.dayNightState.description
            humidity = "\(current.humidity)\("%")"
            sunriseTime = current.sunrise.shortTime
            sunsetTime = current.sunset.shortTime
            windSpeedSymbol = "wind"
            humiditySymbol = "humidity.fill"
            sunriseSymbol = "sunrise"
            sunsetSymbol = "sunset"
            isTwentyFourHoursForecastLoaded = true
            isFiveDaysForecastLoaded = true
            setTemperatureAccordingToUnitNotation()
            setWindSpeedAccordingToMeasurementSystem()
        }

        private func setTwentyFourHoursForecastModel() {
            guard let hourly = weatherModel?.hourly,
                  hourly.count >= Self.numberOfThreeHoursForecastItems else {
                return
            }

            twentyFourHoursForecastModel = Array(hourly[...Self.numberOfThreeHoursForecastItems])
        }

        private func setFiveDaysForecastModel() {
            guard let daily = weatherModel?.daily else { return }
            fiveDaysForecastModel = daily
        }

        private func setTemperatureAccordingToUnitNotation() {
            guard let current = weatherModel?.current else { return }

            let values = TemperatureValue(
                current: current.temperature,
                max: current.maxTemperature,
                min: current.minTemperature
            )

            let temperatureVolume = temperatureVolumeFactory.make(
                by: notationController.temperatureNotation,
                valueInKelvin: values
            )

            temperature = temperatureVolume.current
            temperatureMaxMin = "\(temperatureVolume.max) | \(temperatureVolume.min)"
        }

        private func setWindSpeedAccordingToMeasurementSystem() {
            guard let value = weatherModel?.current.windSpeed else { return }

            let speedVolume = speedVolumeFactory.make(
                by: notationController.measurementSystem,
                valueInMetersPerSec: value
            )

            windSpeed = speedVolume.current
        }

        private func postAppStoreReviewRequest() {
            appStoreReviewCenter.post(.enjoyableTemperatureReached)
        }

        nonisolated static func == (
            lhs: CurrentWeatherView.ViewModel,
            rhs: CurrentWeatherView.ViewModel
        ) -> Bool {
            lhs.locationModel.compoundKey == rhs.locationModel.compoundKey
        }
    }

}
