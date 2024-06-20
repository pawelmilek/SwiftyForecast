//
//  CurrentEntryRepository.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 6/20/24.
//  Copyright © 2024 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

final class CurrentEntryRepository: WeatherEntryRepository {
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
        async let model = fetchWeather(coordinate: location.coordinate)
        let (nameResult, weatherResult) = await (name, model)

        let icon = await fetchIcon(with: model.condition.iconCode)
        return WeatherEntry(
            date: .now,
            locationName: nameResult,
            icon: icon,
            description: weatherResult.condition.description,
            temperature: weatherResult.temperature,
            dayNightState: weatherResult.condition.state,
            hourly: [],
            temperatureRenderer: temperatureRenderer
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

    private func fetchWeather(coordinate: CLLocationCoordinate2D) async -> WeatherModel {
        do {
            let response = try await client.fetchCurrent(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            return parser.parse(current: response)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func fetchIcon(with symbol: String) async -> Data {
        do {
            return try await client.fetchLargeIcon(symbol: symbol)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
