//
//  WeatherProviderDataSource.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/13/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

struct WeatherProviderDataSource {
    struct EntryData {
        let name: String
        let icon: Image
        let description: String
        let temperature: String
        let temperatureMaxMin: String
    }

    private let service: WeatherServiceProtocol
    private let temperatureRenderer: TemperatureRenderer

    init(
        service: WeatherServiceProtocol = WeatherService(),
        temperatureRenderer: TemperatureRenderer = TemperatureRenderer()
    ) {
        self.service = service
        self.temperatureRenderer = temperatureRenderer
    }

    func loadEntryData(for location: CLLocation) async -> EntryData {
        let placemark = await fetchPlacemark(at: location)
        let name = placemark.locality ?? InvalidReference.undefined
        let coordinate = placemark.location?.coordinate ?? location.coordinate
        let model = await fetchCurrentWeather(coordinate: coordinate)
        let icon = await fetchIcon(with: model.icon)

        let readyForDisplayTemperature = temperatureRenderer.render(model.temperatureValue)

        let result = EntryData(
            name: name,
            icon: icon,
            description: model.description,
            temperature: readyForDisplayTemperature.current,
            temperatureMaxMin: readyForDisplayTemperature.maxMin
        )

        return result
    }

    private func fetchPlacemark(at location: CLLocation) async -> CLPlacemark {
        do {
            let placemark = try await Geocoder.fetchPlacemark(at: location)
            return placemark
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func fetchCurrentWeather(coordinate: CLLocationCoordinate2D) async -> CurrentWeatherModel {
        do {
            let response = try await service.fetchCurrent(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            let model = ResponseParser.parse(current: response)
            return model
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func fetchIcon(with symbol: String) async -> Image {
        do {
            let result = try await service.fetchLargeIcon(symbol: symbol)
            let image = Image(uiImage: result)
            return image
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
