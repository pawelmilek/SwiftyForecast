import WidgetKit
import RealmSwift
import CoreLocation
import Combine

@MainActor
final class MainViewControllerViewModel: ObservableObject {
    @Published private(set) var weatherViewModels: [WeatherViewControllerViewModel]
    @Published private(set) var notationSegmentedControlItems: [String]
    @Published private(set) var notationSegmentedControlIndex: Int
    @Published private(set) var locationAuthorizationStatusDenied = false
    @Published private(set) var locationError: Error?
    @Published private(set) var selectedIndex: Int?
    private var locations: Results<LocationModel>?

    private let geocodeLocation: LocationPlaceable
    private let notationSystemStore: NotationSystemStore
    private let measurementSystemNotification: MeasurementSystemNotification
    private let currentLocationRecord: LocationRecord
    private let databaseManager: DatabaseManager
    private let locationManager: LocationManager
    private let reviewManager: ReviewManager
    private let analyticsManager: AnalyticsManager
    private let client: OpenWeatherMapClient
    private let parser: ResponseParser
    private let appStoreReviewCenter: ReviewNotificationCenter
    private var token: NotificationToken?
    private var cancellables = Set<AnyCancellable>()

    init(
        geocodeLocation: LocationPlaceable,
        notationSystemStore: NotationSystemStore,
        measurementSystemNotification: MeasurementSystemNotification,
        currentLocationRecord: LocationRecord,
        databaseManager: DatabaseManager,
        locationManager: LocationManager,
        reviewManager: ReviewManager,
        analyticsManager: AnalyticsManager,
        client: OpenWeatherMapClient,
        parser: ResponseParser,
        appStoreReviewCenter: ReviewNotificationCenter
    ) {
        self.geocodeLocation = geocodeLocation
        self.notationSystemStore = notationSystemStore
        self.measurementSystemNotification = measurementSystemNotification
        self.currentLocationRecord = currentLocationRecord
        self.databaseManager = databaseManager
        self.locationManager = locationManager
        self.reviewManager = reviewManager
        self.analyticsManager = analyticsManager
        self.client = client
        self.parser = parser
        self.appStoreReviewCenter = appStoreReviewCenter
        self.notationSegmentedControlIndex =  notationSystemStore.temperatureNotation.rawValue
        self.notationSegmentedControlItems = [
            TemperatureNotation.fahrenheit.description,
            TemperatureNotation.celsius.description
        ]

        self.weatherViewModels = []
        registerLocationNotificationToken()
        subscirbePublishers()
    }

    deinit {
        token?.invalidate()
    }

    func onViewDidLoad() {
        loadLocations()
    }

    func onSelectIndex(_ index: Int) {
        selectedIndex = index
    }

    func requestLocation() {
        locationManager.requestLocation()
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
                client: client,
                parser: parser,
                measurementSystemNotification: measurementSystemNotification,
                appStoreReviewCenter: appStoreReviewCenter
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
