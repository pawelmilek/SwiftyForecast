//
//  WeatherEntryService.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 6/25/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherEntryService: EntryService {
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

    func load(latitude: Double, longitude: Double) async -> WeatherEntry {
        async let name = fetchPlaceName(at: CLLocation(latitude: latitude, longitude: longitude))
        async let model = fetchWeather(
            latitude: latitude,
            longitude: longitude
        )
        let (nameResult, weatherResult) = await (name, model)
        let icon = await fetchIcon(model.condition.iconCode)

        return WeatherEntry(
            date: .now,
            name: nameResult,
            icon: icon,
            description: weatherResult.condition.description,
            temperature: weatherResult.temperature,
            dayNightState: weatherResult.condition.state,
            hourly: [],
            temperatureFormatterFactory: temperatureFormatterFactory
        )
    }

    private func fetchPlaceName(at location: CLLocation) async -> String {
        do {
            let placemark = try await locationPlace.placemark(at: location)
            let name = placemark.locality ?? InvalidReference.undefined
            return name
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func fetchIcon(_ symbol: String) async -> Data {
        do {
            return try await repository.fetchIcon(symbol: symbol)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func fetchWeather(latitude: Double, longitude: Double) async -> WeatherModel {
        do {
            let response = try await repository.fetchCurrent(latitude: latitude, longitude: longitude)
            return parser.weather(response: response)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
