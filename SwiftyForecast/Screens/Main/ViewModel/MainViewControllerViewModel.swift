import WidgetKit
import RealmSwift
import CoreLocation
import Combine

@MainActor
final class MainViewControllerViewModel: ObservableObject {
    static let firstIndex = 0
    @Published private(set) var currentWeatherViewModels = [WeatherViewControllerViewModel]()
    @Published private(set) var notationSegmentedControlItems: [String]
    @Published private(set) var notationSegmentedControlIndex: Int
    @Published private(set) var locationAuthorizationStatusDenied = false
    @Published private(set) var isRequestingLocation = true
    @Published private(set) var locationError: Error?

    private let geocodeLocation: LocationPlaceable
    private let notationSystemStore: NotationSystemStore
    private let measurementSystemNotification: MeasurementSystemNotification
    private let currentLocationRecord: CurrentLocationRecordProtocol
    private let databaseManager: DatabaseManager
    private let locationManager: LocationManager
    private let reviewManager: ReviewManager
    private let analyticsManager: AnalyticsManager

    private var token: NotificationToken?
    private var cancellables = Set<AnyCancellable>()

    init(
        geocodeLocation: LocationPlaceable,
        notationSystemStore: NotationSystemStore,
        measurementSystemNotification: MeasurementSystemNotification,
        currentLocationRecord: CurrentLocationRecordProtocol,
        databaseManager: DatabaseManager,
        locationManager: LocationManager,
        reviewManager: ReviewManager,
        analyticsManager: AnalyticsManager
    ) {
        self.geocodeLocation = geocodeLocation
        self.notationSystemStore = notationSystemStore
        self.measurementSystemNotification = measurementSystemNotification
        self.currentLocationRecord = currentLocationRecord
        self.databaseManager = databaseManager
        self.locationManager = locationManager
        self.reviewManager = reviewManager
        self.analyticsManager = analyticsManager
        self.notationSegmentedControlIndex =  notationSystemStore.temperatureNotation.rawValue
        self.notationSegmentedControlItems = [
            TemperatureNotation.fahrenheit.description,
            TemperatureNotation.celsius.description
        ]
        registerRealmCollectionNotificationToken()
    }

    deinit {
        token?.invalidate()
    }

    func onViewDidLoad() {
        subscirbePublishers()
    }

    func requestReview(for moment: ReviewDesirableMomentType) {
        reviewManager.requestReview(for: moment)
    }

    private func subscirbePublishers() {
        locationManager.$authorizationStatus
            .sink { [weak self] authorizationStatus in
                guard let self else { return }
                switch authorizationStatus {
                case .notDetermined:
                    locationManager.requestAuthorization()

                case .authorizedWhenInUse, .authorizedAlways:
                    locationManager.startUpdatingLocation()

                default:
                    locationAuthorizationStatusDenied = true
                }
            }
            .store(in: &cancellables)

        locationManager.$currentLocation
            .compactMap { $0 }
            .sink { [self] currentLocation in
                insertCurrentLocation(currentLocation)
            }
            .store(in: &cancellables)

        locationManager.$isRequestingLocation
            .assign(to: \.isRequestingLocation, on: self)
            .store(in: &cancellables)

        locationManager.$error
            .assign(to: \.locationError, on: self)
            .store(in: &cancellables)
    }

    private func registerRealmCollectionNotificationToken() {
        token = try? databaseManager.readAll().observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.setCurrentWeatherViewModels()

            case .update(_, let deletions, let insertions, let modifications):
                debugPrint("deletions: \(deletions)")
                debugPrint("insertions: \(insertions)")
                debugPrint("modifications: \(modifications)")
                self?.setCurrentWeatherViewModels()

            case .error(let error):
                fatalError("File: \(#file), Function: \(#function), line: \(#line) \(error)")
            }
        }
    }

    private func setCurrentWeatherViewModels() {
        currentWeatherViewModels.removeAll()

        if let allSorted = try? databaseManager.readAllSorted() {
            currentWeatherViewModels = allSorted.compactMap {
                WeatherViewControllerViewModel(
                    locationModel: $0,
                    client: OpenWeatherMapClient(decoder: JSONSnakeCaseDecoded()),
                    parser: ResponseParser(),
                    measurementSystemNotification: MeasurementSystemNotification(),
                    appStoreReviewCenter: ReviewNotificationCenter()
                )
            }
        }
    }

    private func insertCurrentLocation(_ location: CLLocation) {
        Task(priority: .userInitiated) {
            do {
                let placemark = try await geocodeLocation.placemark(at: location)
                currentLocationRecord.insert(
                    LocationModel(
                        placemark: placemark,
                        isUserLocation: true
                    )
                )
                reloadWidgetTimeline()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    func index(of location: LocationModel) -> Int? {
        guard let index = try? databaseManager
            .readAllSorted()
            .firstIndex(where: { $0.compoundKey == location.compoundKey }) else { return nil }
        return index
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
