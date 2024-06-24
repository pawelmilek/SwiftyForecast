//
//  EntryRepositoryFactory.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 6/20/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct WeatherEntryRepositoryFactory: EntryRepositoryFactory {
    private let client: Client
    private let locationPlace: LocationPlaceable
    private let parser: ResponseParser
    private let temperatureFormatterFactory: TemperatureFormatterFactoryProtocol

    init(
        client: Client,
        locationPlace: LocationPlaceable,
        parser: ResponseParser,
        temperatureFormatterFactory: TemperatureFormatterFactoryProtocol
    ) {
        self.client = client
        self.locationPlace = locationPlace
        self.parser = parser
        self.temperatureFormatterFactory = temperatureFormatterFactory
    }

    func make(_ isSystemMediumFamily: Bool) -> WeatherEntryRepository {
        return if isSystemMediumFamily {
            ForecastEntryRepository(
                client: client,
                locationPlace: locationPlace,
                parser: parser,
                temperatureFormatterFactory: temperatureFormatterFactory
            )
        } else {
            CurrentEntryRepository(
                client: client,
                locationPlace: locationPlace,
                parser: parser,
                temperatureFormatterFactory: temperatureFormatterFactory
            )
        }
    }
}
