import WidgetKit
import RealmSwift
import CoreLocation
import Combine

@MainActor
final class MainViewControllerViewModel: ObservableObject {
    @Published private(set) var weatherViewModels: [WeatherViewControllerViewModel]
    @Published private(set) var notationControlItems: [String]
    @Published private(set) var notationControlIndex: Int
    @Published private(set) var locationAuthorizationStatusDenied = false
    @Published private(set) var locationError: Error?
    @Published private(set) var selectedIndex: Int?
    @Published private(set) var hasNetworkConnection = true

    private var locations: Results<LocationModel>?

    private let geocodeLocation: LocationPlaceable
    private var notationSettings: NotationSettings
    private let metricSystemNotification: MetricSystemNotification
    private let currentLocationRecord: LocationRecord
    private let databaseManager: DatabaseManager
    private let locationManager: LocationManager
    private let analyticsManager: AnalyticsManager
    private let networkMonitor: NetworkMonitor
    private let service: WeatherServiceProtocol
    private var token: NotificationToken?
    private var cancellables = Set<AnyCancellable>()

    init(
        geocodeLocation: LocationPlaceable,
        notationSettings: NotationSettings,
        metricSystemNotification: MetricSystemNotification,
        currentLocationRecord: LocationRecord,
        databaseManager: DatabaseManager,
        locationManager: LocationManager,
        analyticsManager: AnalyticsManager,
        networkMonitor: NetworkMonitor,
        service: WeatherServiceProtocol
    ) {
        self.geocodeLocation = geocodeLocation
        self.notationSettings = notationSettings
        self.metricSystemNotification = metricSystemNotification
        self.currentLocationRecord = currentLocationRecord
        self.databaseManager = databaseManager
        self.locationManager = locationManager
        self.analyticsManager = analyticsManager
        self.networkMonitor = networkMonitor
        self.service = service
        self.notationControlIndex = notationSettings.temperatureNotation.rawValue
        self.notationControlItems = TemperatureNotation.allCases.map { $0.symbol }
        self.weatherViewModels = []
        registerLocationNotificationToken()
        subscirbePublishers()
    }

    deinit {
        token?.invalidate()
    }

    func onViewDidLoad() {
        loadLocations()
        networkMonitor.start()
    }

    func onSelectIndex(_ index: Int) {
        selectedIndex = index
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    private func subscirbePublishers() {
        networkMonitor.$hasNetworkConnection
            .receive(on: DispatchQueue.main)
            .assign(to: \.hasNetworkConnection, on: self)
            .store(in: &cancellables)

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

        locationManager.$location
            .compactMap { $0 }
            .sink { [self] currentLocation in
                updateLocationRecord(currentLocation)
            }
            .store(in: &cancellables)

        locationManager.$error
            .assign(to: \.locationError, on: self)
            .store(in: &cancellables)
    }

    private func registerLocationNotificationToken() {
        token = try? databaseManager.readAllSorted().observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.invalidateWeatherViewModels()

            case .update(_, let deletions, let insertions, let modifications):
                debugPrint("deletions: \(deletions)")
                debugPrint("insertions: \(insertions)")
                debugPrint("modifications: \(modifications)")
                debugPrint(self!.locations!.description)
                self?.invalidateWeatherViewModels()
                self?.invalidateMainPageData(insertions: insertions, modifications: modifications)

            case .error(let error):
                fatalError("File: \(#file), Function: \(#function), line: \(#line) \(error)")
            }
        }
    }

    private func invalidateMainPageData(insertions: [Int], modifications: [Int]) {
        for index in insertions where locations?[index].isUserLocation ?? false {
            selectedIndex = 0
            return
        }

        for index in modifications where locations?[index].isUserLocation ?? false {
            selectedIndex = 0
            return
        }
    }

    private func invalidateWeatherViewModels() {
        weatherViewModels = locations?.map {
            WeatherViewControllerViewModel(
                compoundKey: $0.compoundKey,
                latitude: $0.latitude,
                longitude: $0.longitude,
                locationName: $0.name,
                service: service,
                metricSystemNotification: metricSystemNotification
            )
        } ?? []
    }

    private func loadLocations() {
        do {
            locations = try databaseManager.readAllSorted()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func updateLocationRecord(_ location: CLLocation) {
        Task {
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
        guard let index = try? databaseManager.readAllSorted()
            .firstIndex(where: { $0.compoundKey == location.compoundKey }) else {
            return nil
        }
        return index
    }

    func onSegmentedControlDidChange(_ selectedSegmentIndex: Int) {
        guard let measurementSystem = MetricSystem(rawValue: selectedSegmentIndex),
              let temperatureNotation = TemperatureNotation(rawValue: selectedSegmentIndex) else {
            return
        }

        notationSettings.metricSystem = measurementSystem
        notationSettings.temperatureNotation = temperatureNotation
        notationControlIndex = temperatureNotation.rawValue
        metricSystemNotification.post()
        reloadWidgetTimeline()

        analyticsManager.send(
            event: MainViewControllerEvent.temperatureNotationSwitched(
                notation: temperatureNotation.symbol
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
