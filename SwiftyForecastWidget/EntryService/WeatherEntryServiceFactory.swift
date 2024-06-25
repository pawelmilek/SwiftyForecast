//
//  WeatherEntryServiceFactory.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 6/20/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation

struct WeatherEntryServiceFactory: EntryServiceFactory {
    private let repository: WeatherRepositoryProtocol
    private let locationPlace: LocationPlaceable
    private let parser: ResponseParser
    private let temperatureFormatterFactory: TemperatureFormatterFactoryProtocol

    init(
        repository: WeatherRepositoryProtocol,
        locationPlace: LocationPlaceable,
        parser: ResponseParser,
        temperatureFormatterFactory: TemperatureFormatterFactoryProtocol
    ) {
        self.repository = repository
        self.locationPlace = locationPlace
        self.parser = parser
        self.temperatureFormatterFactory = temperatureFormatterFactory
    }

    func make(_ isSystemMediumFamily: Bool) -> EntryService {
        return if isSystemMediumFamily {
            ForecastEntryService(
                repository: repository,
                locationPlace: locationPlace,
                parser: parser,
                temperatureFormatterFactory: temperatureFormatterFactory
            )
        } else {
            WeatherEntryService(
                repository: repository,
                locationPlace: locationPlace,
                parser: parser,
                temperatureFormatterFactory: temperatureFormatterFactory
            )
        }
    }
}
