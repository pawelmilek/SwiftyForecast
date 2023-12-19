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
        let hourly: [HourlyEntryData]
    }

    struct HourlyEntryData {
        let icon: Image
        let temperature: String
        let time: String

        init(
            icon: Image,
            temperature: String,
            time: String
        ) {
            self.icon = icon
            self.temperature = temperature
            self.time = time
        }
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
        let currentModel = await fetchCurrentWeather(coordinate: coordinate)
        let currentIcon = await fetchIcon(with: currentModel.icon)
        let hourlyEntryData = await loadHourlyEntryData(coordinate: coordinate)

        let readyForDisplayCurrentTemperature = temperatureRenderer.render(currentModel.temperatureValue)
        let result = EntryData(
            name: name,
            icon: currentIcon,
            description: currentModel.description,
            temperature: readyForDisplayCurrentTemperature.current,
            temperatureMaxMin: readyForDisplayCurrentTemperature.maxMin,
            hourly: hourlyEntryData
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

    private func loadHourlyEntryData(coordinate: CLLocationCoordinate2D) async -> [HourlyEntryData] {
        let models = await fetchTwelveHoursForecastWeather(coordinate: coordinate)

        var hourlyEntryData = [HourlyEntryData]()
        for model in models {
            let icon = await fetchIcon(with: model.icon)
            let data = HourlyEntryData(
                icon: icon,
                temperature: temperatureRenderer.render(model.temperature).current,
                time: model.date.shortTime
            )
            hourlyEntryData.append(data)
        }
        return hourlyEntryData
    }

    private func fetchTwelveHoursForecastWeather(coordinate: CLLocationCoordinate2D) async -> [HourlyForecastModel] {
        do {
            let forecast = try await service.fetchForecast(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            let forecastModel = ResponseParser.parse(forecast: forecast)
            return Array(forecastModel.hourly.prefix(upTo: 4))
        } catch {
            fatalError(error.localizedDescription)
        }
    }

}
