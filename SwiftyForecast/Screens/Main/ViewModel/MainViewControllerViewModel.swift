import WidgetKit
import RealmSwift
import CoreLocation
import Combine

@MainActor
final class MainViewControllerViewModel: ObservableObject {
    static let userLocationPageIndex = 0

    private(set) var currentPageIndex = userLocationPageIndex
    @Published private(set) var currentWeatherViewModels = [WeatherViewControllerViewModel]()
    @Published private(set) var notationSegmentedControlIndex: Int
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

    private let geocodeLocation: GeocodeLocationProtocol
    private let notationSystemStore: NotationSystemStore
    private let measurementSystemNotification: MeasurementSystemNotification
    private let databaseManager: DatabaseManager
    private let analyticsManager: AnalyticsManager
    private var token: NotificationToken?
    private var cancellables = Set<AnyCancellable>()

    init(
        geocodeLocation: GeocodeLocationProtocol,
        notationSystemStore: NotationSystemStore,
        measurementSystemNotification: MeasurementSystemNotification,
        databaseManager: DatabaseManager,
        analyticsManager: AnalyticsManager
    ) {
        self.geocodeLocation = geocodeLocation
        self.notationSystemStore = notationSystemStore
        self.measurementSystemNotification = measurementSystemNotification
        self.databaseManager = databaseManager
        self.analyticsManager = analyticsManager
        self.notationSegmentedControlIndex =  notationSystemStore.temperatureNotation.rawValue
        registerRealmCollectionNotificationToken()
    }

    deinit {
        token?.invalidate()
    }

    func donateInformationVisitEvent() {
        Task(priority: .userInitiated) {
            await InformationTip.visitViewEvent.donate()
        }
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
            currentWeatherViewModels = allSorted.compactMap { .init(locationModel: $0) }
        } else {
            currentWeatherViewModels.removeAll()
        }
    }

    func onDidUpdateLocation(_ location: CLLocation) {
        Task(priority: .userInitiated) {
            do {
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
        guard let measurementSystem = MeasurementSystem(rawValue: selectedSegmentIndex),
              let temperatureNotation = TemperatureNotation(rawValue: selectedSegmentIndex) else {
            return
        }

        notationSystemStore.measurementSystem = measurementSystem
        notationSystemStore.temperatureNotation = temperatureNotation
        notationSegmentedControlIndex = temperatureNotation.rawValue
        measurementSystemNotification.post()
        reloadWidgetTimeline()
        analyticsManager.send(
            event: MainViewControllerEvent.temperatureNotationSwitched(
                notation: temperatureNotation.name
            )
        )
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
