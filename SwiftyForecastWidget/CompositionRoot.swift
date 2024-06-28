//
//  CompositionRoot.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 6/28/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import CoreLocation

enum CompositionRoot {
    static let provider = WeatherTimelineProvider(
        locationManager: WidgetLocationManager(),
        repositoryFactory: WeatherEntryServiceFactory(
            repository: WeatherRepository(
                client: OpenWeatherClient(
                    decoder: JSONSnakeCaseDecoded()
                )
            ),
            locationPlace: GeocodedLocation(
                geocoder: CLGeocoder()
            ),
            parser: WeatherResponseParser(),
            temperatureFormatterFactory: TemperatureFormatterFactory(
                notationStorage: NotationSettingsStorage()
            )
        )
    )
}
