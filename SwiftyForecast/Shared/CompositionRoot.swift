//
//  CompositionRoot.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/28/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

@MainActor
enum CompositionRoot {
    static var mainViewModel: MainViewControllerViewModel {
        MainViewControllerViewModel(
            geocodeLocation: geocodeLocation,
            notationSettings: notationSettings,
            metricSystemNotification: metricSystemNotification,
            currentLocationRecord: currentLocationRecord,
            databaseManager: databaseManager,
            locationManager: locationManager,
            analyticsService: analyticsService,
            networkMonitor: networkMonitor,
            service: service
        )
    }

    static var aboutViewModel: AboutViewModel {
        .init(
            bundle: .main,
            buildConfiguration: buildConfiguration,
            networkResourceFactory: NetworkResourceFactory(),
            analyticsService: analyticsService
        )
    }

    static var appearanceViewModel: AppearanceViewViewModel {
        .init(notificationCenter: .default, analyticsService: analyticsService)
    }

//    static var cardViewModel: WeatherCardViewViewModel {
//        WeatherCardViewViewModel(
//            latitude: <#T##Double#>,
//            longitude: <#T##Double#>,
//            locationName: <#T##String#>,
//            service: <#T##any WeatherServiceProtocol#>,
//            temperatureFormatterFactory: <#T##any TemperatureFormatterFactoryProtocol#>,
//            speedFormatterFactory: <#T##any SpeedFormatterFactoryProtocol#>,
//            metricSystemNotification: <#T##any MetricSystemNotification#>
//        )
//    }

    private static let geocodeLocation = GeocodedLocation(geocoder: CLGeocoder())
    private static let notationSettings = NotationSettingsStorage()
    private static let metricSystemNotification = MetricSystemNotificationCenterAdapter(notificationCenter: .default)

    private static var currentLocationRecord: CurrentLocationRecord {
        CurrentLocationRecord(databaseManager: databaseManager)
    }

    static var databaseManager: DatabaseManager {
        RealmManager()
    }

    private static let locationManager = LocationManager()
    private static let analyticsService = FirebaseAnalyticsService()
    private static let networkMonitor = NetworkMonitor()
    private static let service = WeatherService(repository: repository, parse: WeatherResponseParser())
    private static let repository = WeatherRepository(client: client)
    private static let client = OpenWeatherClient(decoder: JSONSnakeCaseDecoded())
    private static let buildConfiguration = BuildConfigurationFile(bundle: .main)
}
