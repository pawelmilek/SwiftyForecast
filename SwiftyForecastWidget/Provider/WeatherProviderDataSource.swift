//
//  WeatherProviderDataSource.swift
//  SwiftyForecastWidgetExtension
//
//  Created by Pawel Milek on 12/13/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import Foundation
import CoreLocation

final class WeatherProviderDataSource {
    private let client: WeatherClient
    private let locationPlace: LocationPlaceable
    private let parser: ResponseParser

    init(
        client: WeatherClient,
        locationPlace: LocationPlaceable,
        parser: ResponseParser
    ) {
        self.client = client
        self.locationPlace = locationPlace
        self.parser = parser
    }

    func loadEntryData(for location: CLLocation) async -> WeatherEntry {
        let (name, currentModel) = await fetchLocationNameAndCurrentWeather(location: location)
        let icon = await fetchIcon(with: currentModel.condition.iconCode)

        let result = WeatherEntry(
            date: .now,
            locationName: name,
            icon: icon,
            description: currentModel.condition.description,
            temperatureValue: currentModel.temperature,
            dayNightState: currentModel.condition.state,
            hourly: [],
            temperatureRenderer: TemperatureRenderer()
        )

        return result
    }

    func loadEntryDataWithHourlyForecast(
        for location: CLLocation
    ) async -> WeatherEntry {
        let (name, currentModel) = await fetchLocationNameAndCurrentWeather(location: location)
        let (icon, hourlyEntryData) = await fetchConditionIconAndHourlyForecast(
            location: location,
            icon: currentModel.condition.iconCode
        )

        let result = WeatherEntry(
            date: .now,
            locationName: name,
            icon: icon,
            description: currentModel.condition.description,
            temperatureValue: currentModel.temperature,
            dayNightState: currentModel.condition.state,
            hourly: hourlyEntryData,
            temperatureRenderer: TemperatureRenderer()
        )

        return result
    }

    private func fetchLocationNameAndCurrentWeather(
        location: CLLocation
    ) async -> (name: String, model: WeatherModel) {
        async let nameResult = fetchPlacemark(for: location)
        async let modelResult = fetchCurrentWeather(coordinate: location.coordinate)
        let (name, model) = await (nameResult, modelResult)
        return (name, model)
    }

    private func fetchConditionIconAndHourlyForecast(
        location: CLLocation,
        icon: String
    ) async -> (icon: Data, models: [HourlyEntry]) {
        async let iconResult = fetchIcon(with: icon)
        async let hourlyEntryDataResult = loadHourlyEntryData(location: location)
        let (icon, hourlyEntryData) = await (iconResult, hourlyEntryDataResult)
        return (icon, hourlyEntryData)
    }

    private func fetchPlacemark(for location: CLLocation) async -> String {
        let placemark = await requestPlacemark(at: location)
        let name = placemark.locality ?? InvalidReference.undefined
        return name
    }

    private func requestPlacemark(at location: CLLocation) async -> CLPlacemark {
        do {
            let placemark = try await locationPlace.placemark(at: location)
            return placemark
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func fetchCurrentWeather(coordinate: CLLocationCoordinate2D) async -> WeatherModel {
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

    private func fetchIcon(with symbol: String) async -> Data {
        do {
            let result = try await client.fetchLargeIcon(symbol: symbol)
            return result

        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func loadHourlyEntryData(location: CLLocation) async -> [HourlyEntry] {
        let models = await fetchTwelveHoursForecastWeather(coordinate: location.coordinate)

        var hourlyEntry = [HourlyEntry]()
        for model in models {
            let icon = await fetchIcon(with: model.icon)
            if let temperature = model.temperature {
                let data = HourlyEntry(
                    icon: icon,
                    time: model.date.formatted(date: .omitted, time: .shortened),
                    temperatureValue: TemperatureValue(current: temperature)
                )
                hourlyEntry.append(data)
            }
        }
        return hourlyEntry
    }

    private func fetchTwelveHoursForecastWeather(coordinate: CLLocationCoordinate2D) async -> [HourlyForecastModel] {
        do {
            let forecast = try await client.fetchForecast(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            let forecastModel = ResponseParser().parse(forecast: forecast)
            return Array(forecastModel.hourly.prefix(upTo: 4))
        } catch {
            fatalError(error.localizedDescription)
        }
    }

}
