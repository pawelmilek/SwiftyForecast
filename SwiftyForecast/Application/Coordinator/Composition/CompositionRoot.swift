//
//  CompositionRoot.swift
//  Swifty Forecast
//
//  Created by Pawel Milek on 6/28/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import UIKit

@MainActor
enum CompositionRoot {
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
                viewModel: WeatherViewControllerViewModel(
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
                cardViewModel: WeatherCardViewViewModel(
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
                ),
                coder: coder
            )
        }

        return viewController
    }
}
