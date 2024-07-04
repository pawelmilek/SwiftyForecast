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
                    geocodeLocation: GeocodedLocation(
                        geocoder: CLGeocoder()
                    ),
                    notationSettings: NotationSettingsStorage(),
                    metricSystemNotification: MetricSystemNotificationAdapter(
                        notificationCenter: .default
                    ),
                    currentLocationRecord: CurrentLocationRecord(
                        databaseManager: RealmManager()
                    ),
                    databaseManager: RealmManager(),
                    locationManager: LocationManager(),
                    analyticsService: FirebaseAnalyticsService(),
                    networkMonitor: NetworkMonitor()
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
                    service: WeatherService(
                        repository: WeatherRepository(
                            client: OpenWeatherClient(
                                decoder: JSONSnakeCaseDecoded()
                            )
                        ),
                        parse: WeatherResponseParser()
                    ),
                    metricSystemNotification: MetricSystemNotificationAdapter(
                        notificationCenter: .default
                    )
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
            service: WeatherService(
                repository: WeatherRepository(
                    client: OpenWeatherClient(
                        decoder: JSONSnakeCaseDecoded()
                    )
                ),
                parse: WeatherResponseParser()
            ),
            temperatureFormatterFactory: TemperatureFormatterFactory(
                notationStorage: NotationSettingsStorage()
            ),
            speedFormatterFactory: SpeedFormatterFactory(
                notationStorage: NotationSettingsStorage()
            ),
            metricSystemNotification: MetricSystemNotificationAdapter(
                notificationCenter: .default
            )
        )
    }

    static func searchedLocationWeatherViewModel(
        _ locationModel: LocationModel
    ) -> SearchedLocationWeatherViewViewModel {
        .init(
            location: locationModel,
            service: WeatherService(
                repository: WeatherRepository(
                    client: OpenWeatherClient(
                        decoder: JSONSnakeCaseDecoded()
                    )
                ),
                parse: WeatherResponseParser()
            ),
            databaseManager: RealmManager(),
            storeReviewManager: StoreReviewManager(
                store: StoreReviewController(
                    connectedScenes: UIApplication.shared.connectedScenes
                ),
                storage: ReviewedVersionStorageAdapter(
                    adaptee: .standard
                ),
                bundle: .main
            ),
            analyticsService: FirebaseAnalyticsService()
        )
    }

    static func dailyViewModel(_ model: DailyForecastModel) -> DailyViewCellViewModel {
        .init(
            model: model,
            temperatureFormatterFactory: TemperatureFormatterFactory(
                notationStorage: NotationSettingsStorage()
            )
        )
    }

}
