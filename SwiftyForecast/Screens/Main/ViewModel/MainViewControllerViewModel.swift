//
//  MainViewControllerViewModel.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/10/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import WidgetKit
import RealmSwift
import CoreLocation
import Combine

@MainActor
final class MainViewControllerViewModel: ObservableObject {
    @Published private(set) var notationControlItems: [String]
    @Published private(set) var notationControlIndex: Int
    @Published private(set) var locationAuthorizationStatusDenied = false
    @Published private(set) var locationError: Error?
    @Published private(set) var selectedIndex: Int?
    @Published private(set) var hasNetworkConnection = true
    @Published private(set) var locations: [LocationModel] = []

    private let geocodeLocation: LocationPlaceable
    private var notationSettings: NotationSettings
    private let metricSystemNotification: MetricSystemNotification
    private let currentLocationRecord: LocationRecord
    private let databaseManager: DatabaseManager
    private let locationManager: LocationManager
    private let analyticsService: AnalyticsService
    private let networkMonitor: NetworkMonitor
    private var cancellables = Set<AnyCancellable>()

    init(
        geocodeLocation: LocationPlaceable,
        notationSettings: NotationSettings,
        metricSystemNotification: MetricSystemNotification,
        currentLocationRecord: LocationRecord,
        databaseManager: DatabaseManager,
        locationManager: LocationManager,
        analyticsService: AnalyticsService,
        networkMonitor: NetworkMonitor
    ) {
        self.geocodeLocation = geocodeLocation
        self.notationSettings = notationSettings
        self.metricSystemNotification = metricSystemNotification
        self.currentLocationRecord = currentLocationRecord
        self.databaseManager = databaseManager
        self.locationManager = locationManager
        self.analyticsService = analyticsService
        self.networkMonitor = networkMonitor
        self.notationControlIndex = notationSettings.temperatureNotation.rawValue
        self.notationControlItems = TemperatureNotation.allCases.map { $0.symbol }
        subscirbePublishers()
    }

    func onViewDidLoad() {
        loadLocations()
        networkMonitor.start()
        debugPrint(databaseManager.description)
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

    private func loadLocations() {
        do {
            _ = try databaseManager.readAllSorted()
                .collectionPublisher
                .print()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    debugPrint(completion)
                }, receiveValue: { [weak self] allSorted in
                    self?.locations = allSorted.map { LocationModel(value: $0) }
                })
                .store(in: &cancellables)
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

        analyticsService.send(
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
