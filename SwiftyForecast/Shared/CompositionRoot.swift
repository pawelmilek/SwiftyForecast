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
    static var mainViewModel: MainViewControllerViewModel {
        .init(
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

    static func weatherViewModel(
        compoundKey: String,
        latitude: Double,
        longitude: Double,
        name: String
    ) -> WeatherViewControllerViewModel {
        .init(
            compoundKey: compoundKey,
            latitude: latitude,
            longitude: longitude,
            name: name,
            service: service,
            metricSystemNotification: metricSystemNotification
        )
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

    static func locationRowViewModel(
        _ locationModel: LocationModel
    ) -> LocationRowViewModel {
        .init(
            location: locationModel,
            service: service,
            temperatureFormatterFactory: temperatureFormatterFactory
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
            analyticsService: analyticsService
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

    static var themeViewModel: ThemeViewViewModel {
        .init(
            notificationCenter: .default,
            analyticsService: analyticsService
        )
    }

    static func hourlyViewModel(_ model: HourlyForecastModel) -> HourlyViewCellViewModel {
        .init(
            model: model,
            temperatureFormatterFactory: temperatureFormatterFactory
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
    private static let analyticsService = FirebaseAnalyticsService()
    private static let networkMonitor = NetworkMonitor()
    private static let buildConfiguration = BuildConfigurationFile(bundle: .main)
    private static let temperatureFormatterFactory = TemperatureFormatterFactory(notationStorage: notationSettings)
    private static let speedFormatterFactory = SpeedFormatterFactory(notationStorage: notationSettings)
    private static let notationSettings = NotationSettingsStorage()
    private static let metricSystemNotification = MetricSystemNotificationCenterAdapter(notificationCenter: .default)
}
