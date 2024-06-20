//
//  WeatherEntryRepository.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/13/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

final class WeatherEntryRepository {
    private let client: WeatherClient
    private let locationPlace: LocationPlaceable
    private let parser: ResponseParser
    private let temperatureRenderer: TemperatureRenderer

    init(
        client: WeatherClient,
        locationPlace: LocationPlaceable,
        parser: ResponseParser,
        temperatureRenderer: TemperatureRenderer
    ) {
        self.client = client
        self.locationPlace = locationPlace
        self.parser = parser
        self.temperatureRenderer = temperatureRenderer
    }

    func load(for location: CLLocation) async -> WeatherEntry {
        async let name = fetchPlaceName(at: location)
        async let model = fetchWeather(coordinate: location.coordinate)
        let (nameResult, weatherResult) = await (name, model)

        let icon = await fetchIcon(with: model.condition.iconCode)
        return entry(name: nameResult, icon: icon, weather: weatherResult, hourly: [])
    }

    func loadWithHourlyForecast(for location: CLLocation) async -> WeatherEntry {
        async let name = fetchPlaceName(at: location)
        async let weather = fetchWeather(coordinate: location.coordinate)
        async let hourlyForecast = fetchHourlyForecast(coordinate: location.coordinate)
        let (nameResult, weatherResult, hourlyForecastResult) = await (name, weather, hourlyForecast)

        async let icon = fetchIcon(with: weatherResult.condition.iconCode)
        async let hourlyEntries = hourlyEntries(hourlyForecastResult)
        let (iconResult, hourlyEntriesResult) = await (icon, hourlyEntries)
        return entry(name: nameResult, icon: iconResult, weather: weatherResult, hourly: hourlyEntriesResult)
    }

    private func entry(
        name: String,
        icon: Data,
        weather: WeatherModel,
        hourly: [HourlyEntry]
    ) -> WeatherEntry {
        WeatherEntry(
            date: .now,
            locationName: name,
            icon: icon,
            description: weather.condition.description,
            temperature: weather.temperature,
            dayNightState: weather.condition.state,
            hourly: hourly,
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
