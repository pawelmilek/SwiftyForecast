//
//  CompositionRoot.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/28/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import UIKit
import CoreLocation

@MainActor
enum CompositionRoot {
    static func mainViewController(coordinator: Coordinator) -> MainViewController {
        let storyboard = UIStoryboard(storyboard: .main)
        let viewController = storyboard.instantiateViewController(
            identifier: MainViewController.storyboardIdentifier
        ) { coder in
            MainViewController(
                viewModel: .init(
                    geocodeLocation: geocodeLocation,
                    notationSettings: notationSettings,
                    metricSystemNotification: metricSystemNotification,
                    currentLocationRecord: currentLocationRecord,
                    databaseManager: databaseManager,
                    locationManager: locationManager,
                    analyticsService: FirebaseAnalyticsService(),
                    networkMonitor: networkMonitor
                ),
                coordinator: coordinator,
                coder: coder
            )
        }

        return viewController
    }

    static func weatherViewController(
        compoundKey: String,
        latitude: Double,
        longitude: Double,
        name: String
    ) -> WeatherViewController {
        let storyboard = UIStoryboard(storyboard: .main)
        let viewController = storyboard.instantiateViewController(
            identifier: WeatherViewController.storyboardIdentifier
        ) { coder in
            WeatherViewController(
                viewModel: .init(
                    compoundKey: compoundKey,
                    latitude: latitude,
                    longitude: longitude,
                    name: name,
                    service: service,
                    metricSystemNotification: metricSystemNotification
                ),
                cardViewModel: Self.cardViewModel(
                    latitude: latitude,
                    longitude: longitude,
                    name: name
                ),
                coder: coder
            )
        }

        return viewController
    }

    static func cardViewModel(
        latitude: Double,
        longitude: Double,
        name: String
    ) -> WeatherCardViewViewModel {
        .init(
            latitude: latitude,
            longitude: longitude,
            name: name,
            service: service,
            temperatureFormatterFactory: temperatureFormatterFactory,
            speedFormatterFactory: speedFormatterFactory,
            metricSystemNotification: metricSystemNotification
        )
    }

    static func searchedLocationWeatherViewModel(
        _ locationModel: LocationModel
    ) -> SearchedLocationWeatherViewViewModel {
        .init(
            location: locationModel,
            service: service,
            databaseManager: databaseManager,
            storeReviewManager: storeReviewManager,
            analyticsService: FirebaseAnalyticsService()
        )
    }

    static func dailyViewModel(_ model: DailyForecastModel) -> DailyViewCellViewModel {
        .init(
            model: model,
            temperatureFormatterFactory: temperatureFormatterFactory
        )
    }

    static var databaseManager: DatabaseManager {
        RealmManager()
    }

    private static let service = WeatherService(
        repository: repository,
        parse: WeatherResponseParser()
    )

    private static let repository = WeatherRepository(
        client: OpenWeatherClient(
            decoder: JSONSnakeCaseDecoded()
        )
    )

    private static let storeReviewManager = StoreReviewManager(
        store: StoreReviewController(connectedScenes: UIApplication.shared.connectedScenes),
        storage: ReviewedVersionStorageAdapter(adaptee: .standard),
        bundle: .main
    )

    private static let geocodeLocation = GeocodedLocation(geocoder: CLGeocoder())
    private static let currentLocationRecord = CurrentLocationRecord(databaseManager: databaseManager)
    private static let locationManager = LocationManager()
    private static let networkMonitor = NetworkMonitor()
    private static let temperatureFormatterFactory = TemperatureFormatterFactory(notationStorage: notationSettings)
    private static let speedFormatterFactory = SpeedFormatterFactory(notationStorage: notationSettings)
    private static let notationSettings = NotationSettingsStorage()
    private static let metricSystemNotification = MetricSystemNotificationCenterAdapter(notificationCenter: .default)
}
