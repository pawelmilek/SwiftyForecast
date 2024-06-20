//
//  ForecastEntryRepository.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 6/20/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

final class ForecastEntryRepository: WeatherEntryRepository {
    private let client: WeatherClient
    private let locationPlace: LocationPlaceable
    private let parser: WeatherParser
    private let temperatureRenderer: TemperatureRenderer

    init(
        client: WeatherClient,
        locationPlace: LocationPlaceable,
        parser: WeatherParser,
        temperatureRenderer: TemperatureRenderer
    ) {
        self.client = client
        self.locationPlace = locationPlace
        self.parser = parser
        self.temperatureRenderer = temperatureRenderer
    }

    func load(for location: CLLocation) async -> WeatherEntry {
        async let name = fetchPlaceName(at: location)
        async let weather = fetchWeather(coordinate: location.coordinate)
        async let hourlyForecast = fetchHourlyForecast(coordinate: location.coordinate)
        let (nameResult, weatherResult, hourlyForecastResult) = await (name, weather, hourlyForecast)

        async let icon = fetchIcon(with: weatherResult.condition.iconCode)
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
            temperatureRenderer: temperatureRenderer
        )
    }

    private func hourlyEntries(_ hourlyForecast: [HourlyForecastModel]) async -> [HourlyEntry] {
        var entires = [HourlyEntry]()

        for model in Array(hourlyForecast.prefix(upTo: 4)) {
            let icon = await fetchIcon(with: model.icon)
            let data = HourlyEntry(
                icon: icon,
                date: model.date,
                temperature: Temperature(current: model.temperature ?? 0)
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

    private func fetchWeather(coordinate: CLLocationCoordinate2D) async -> WeatherModel {
        do {
            let response = try await client.fetchCurrent(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            let model = parser.parse(current: response)
            return model
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func fetchHourlyForecast(coordinate: CLLocationCoordinate2D) async -> [HourlyForecastModel] {
        do {
            let response = try await client.fetchForecast(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            let forecast = parser.parse(forecast: response)
            return forecast.hourly
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func fetchIcon(with symbol: String) async -> Data {
        do {
            let result = try await client.fetchLargeIcon(symbol: symbol)
            return result

        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
