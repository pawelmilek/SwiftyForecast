//
//  ForecastEntryService.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 6/25/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

struct ForecastEntryService: EntryService {
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
        async let weather = fetchWeather(latitude: latitude, longitude: longitude)
        async let hourlyForecast = fetchHourlyForecast(latitude: latitude, longitude: longitude)
        let (nameResult, weatherResult, hourlyForecastResult) = await (name, weather, hourlyForecast)

        async let icon = fetchIcon(weatherResult.condition.iconCode)
        async let hourlyEntries = hourlyEntries(hourlyForecastResult)
        let (iconResult, hourlyEntriesResult) = await (icon, hourlyEntries)

        return WeatherEntry(
            date: .now,
            locationName: nameResult,
            icon: iconResult,
            description: weatherResult.condition.description,
            temperature: weatherResult.temperature,
            dayNightState: weatherResult.condition.state,
            hourly: hourlyEntriesResult,
            temperatureFormatterFactory: temperatureFormatterFactory
        )
    }

    private func hourlyEntries(_ hourlyForecast: [HourlyForecastModel]) async -> [HourlyEntry] {
        var entires = [HourlyEntry]()

        for model in Array(hourlyForecast.prefix(upTo: 4)) {
            let icon = await fetchIcon(model.icon)
            let data = HourlyEntry(
                icon: icon,
                date: model.date,
                temperature: Temperature(current: model.temperature ?? 0),
                temperatureFormatterFactory: temperatureFormatterFactory
            )
            entires.append(data)
        }
        return entires
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

    private func fetchHourlyForecast(latitude: Double, longitude: Double) async -> [HourlyForecastModel] {
        do {
            let response = try await repository.fetchForecast(latitude: latitude, longitude: longitude)
            let forecast = parser.forecast(response: response)
            return forecast.hourly
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
