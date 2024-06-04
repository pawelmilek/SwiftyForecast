import UIKit
import WidgetKit
import RealmSwift
import SafariServices
import CoreLocation
import Combine

@MainActor
final class MainViewControllerViewModel: ObservableObject {
    static let userLocationPageIndex = 0

    private(set) var currentPageIndex = userLocationPageIndex
    @Published private(set) var currentWeatherViewModels = [WeatherViewControllerViewModel]()
    @Published private var hasValidatedUserLocation = false
    @Published private var hasUpdatedViewModels = false

    var shouldNavigateToCurrentPage: AnyPublisher<Bool, Never> {
        return Publishers.Zip($hasValidatedUserLocation, $hasUpdatedViewModels)
            .map { $0.0 && $0.1 }
            .eraseToAnyPublisher()
    }

    var notationSegmentedControlItems: [String] {
        [TemperatureNotation.fahrenheit.description,
         TemperatureNotation.celsius.description]
    }

    var notationSegmentedControlIndex: Int {
        notationController.temperatureNotation.rawValue
    }

    var powerByURL: URL? {
        URL(string: "https://openweathermap.org")
    }

    var numberOfLocations: Int {
        let result = try? databaseManager.readAll().count
        return result ?? 0
    }

    private let service: WeatherServiceProtocol
    private let notationController: NotationController
    private let measurementSystemNotification: MeasurementSystemNotification
    private let databaseManager: DatabaseManager
    private let logEvent: ForecastLogEvent
    private var token: NotificationToken?
    private var cancellables = Set<AnyCancellable>()

    convenience init(service: WeatherServiceProtocol) {
        self.init(
            service: service,
            notationController: NotationController(),
            measurementSystemNotification: MeasurementSystemNotification(),
            databaseManager: RealmManager.shared,
            logEvent: ForecastLogEvent(service: AnalyticsService())
        )
    }

    init(
        service: WeatherServiceProtocol,
        notationController: NotationController = NotationController(),
        measurementSystemNotification: MeasurementSystemNotification = MeasurementSystemNotification(),
        databaseManager: DatabaseManager = RealmManager.shared,
        logEvent: ForecastLogEvent = ForecastLogEvent(service: AnalyticsService())
    ) {
        self.service = service
        self.notationController = notationController
        self.measurementSystemNotification = measurementSystemNotification
        self.databaseManager = databaseManager
        self.logEvent = logEvent
        registerRealmCollectionNotificationToken()
    }

    deinit {
        token?.invalidate()
    }

    private func registerRealmCollectionNotificationToken() {
        token = try? databaseManager.readAll().observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.setCurrentWeatherViewModels()

            case .update:
                self?.setCurrentWeatherViewModels()
                self?.hasUpdatedViewModels = true

            case .error(let error):
                fatalError("File: \(#file), Function: \(#function), line: \(#line) \(error)")
            }
        }
    }

    private func setCurrentWeatherViewModels() {
        if let allSorted = try? databaseManager.readAllSorted() {
            currentWeatherViewModels.removeAll()
            currentWeatherViewModels = allSorted.compactMap { .init(locationModel: $0, service: service) }
        } else {
            currentWeatherViewModels.removeAll()
        }
    }

    func onDidUpdateLocation(_ location: CLLocation) {
        Task(priority: .userInitiated) {
            do {
                let geocodeLocation = GeocodeLocation(geocoder: CLGeocoder())
                let placemark = try await geocodeLocation.requestPlacemark(at: location)
                let newLocation = LocationModel(placemark: placemark, isUserLocation: true)
                let entryValidator = UserLocationEntryValidator(location: newLocation)
                hasValidatedUserLocation = entryValidator.validate()
                reloadWidgetTimeline()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    func index(of location: LocationModel) -> Int? {
        guard let index = try? databaseManager.readAllSorted()
            .firstIndex(where: { $0.compoundKey == location.compoundKey }) else { return nil }
        return index
    }

    func onDidChangePageNavigation(index: Int) {
        resetUpdatePublishers()
        currentPageIndex = index
    }

    func onViewDidDisappear() {
        resetUpdatePublishers()
    }

    func resetUpdatePublishers() {
        hasUpdatedViewModels = false
        hasValidatedUserLocation = false
    }

    func onSegmentedControlDidChange(_ selectedSegmentIndex: Int) {
        guard let selectedMeasurementSystem = MeasurementSystem(rawValue: selectedSegmentIndex),
              let selectedTemperatureNotation = TemperatureNotation(rawValue: selectedSegmentIndex) else {
            return
        }

        notationController.measurementSystem = selectedMeasurementSystem
        notationController.temperatureNotation = selectedTemperatureNotation
        postDidChangeMeasurementSystem()
        unitSelectionHapticFeedback()
        reloadWidgetTimeline()
        logEvent.logSwitchTempNotationEvent(value: selectedTemperatureNotation.name)
    }

    private func postDidChangeMeasurementSystem() {
        measurementSystemNotification.post()
    }

    private func unitSelectionHapticFeedback() {
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.selectionChanged()
    }

    func showEnableLocationServicesPrompt(at navigationController: UINavigationController) {
        guard let viewController = navigationController.viewControllers.first else { return }

        viewController.navigationItem.prompt = "Please enable location services"
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            viewController.navigationItem.prompt = nil
            navigationController.viewIfLoaded?.setNeedsLayout()
        }

        navigationController.viewIfLoaded?.setNeedsLayout()
    }

    private func reloadWidgetTimeline() {
        WidgetCenter.shared.getCurrentConfigurations { result in
            guard case .success(let widgets) = result else { return }

            Task { @MainActor in
                if let widget = widgets.first {
                    WidgetCenter.shared.reloadTimelines(ofKind: widget.kind)
                }
            }
        }
    }
}
