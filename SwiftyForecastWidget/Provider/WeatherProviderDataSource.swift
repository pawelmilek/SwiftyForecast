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

final class WeatherProviderDataSource {
    private let service: WeatherServiceProtocol
    private var location: CLLocation?

    init(service: WeatherServiceProtocol = WeatherService()) {
        self.service = service
    }

    func loadEntryData(for location: CLLocation) async -> WeatherEntry {
        self.location = location
        let (name, currentModel) = await fetchLocationNameAndCurrentWeather()
        let icon = await fetchIcon(with: currentModel.icon)

        let result = WeatherEntry(
            date: .now,
            locationName: name,
            icon: icon,
            description: currentModel.description,
            temperatureValue: currentModel.temperatureValue,
            dayNightState: currentModel.dayNightState,
            hourly: []
        )

        return result
    }

    func loadEntryDataWithHourlyForecast(for location: CLLocation) async -> WeatherEntry {
        self.location = location
        let (name, currentModel) = await fetchLocationNameAndCurrentWeather()
        let (icon, hourlyEntryData) = await fetchConditionIconAndHourlyForecast(currentModel.icon)

        let result = WeatherEntry(
            date: .now,
            locationName: name,
            icon: icon,
            description: currentModel.description,
            temperatureValue: currentModel.temperatureValue,
            dayNightState: currentModel.dayNightState,
            hourly: hourlyEntryData
        )

        return result
    }

    private func fetchLocationNameAndCurrentWeather() async -> (name: String, model: CurrentWeatherModel) {
        async let nameResult = fetchLocationName()
        async let modelResult = fetchCurrentWeather()
        let (name, model) = await (nameResult, modelResult)
        return (name, model)
    }

    private func fetchConditionIconAndHourlyForecast(_ icon: String) async -> (icon: Image, models: [HourlyEntry]) {
        async let iconResult = fetchIcon(with: icon)
        async let hourlyEntryDataResult = loadHourlyEntryData()
        let (icon, hourlyEntryData) = await (iconResult, hourlyEntryDataResult)
        return (icon, hourlyEntryData)
    }

    private func fetchLocationName() async -> String {
        guard let location else { return "" }

        let placemark = await fetchPlacemark(at: location)
        let name = placemark.locality ?? InvalidReference.undefined
        return name
    }

    private func fetchPlacemark(at location: CLLocation) async -> CLPlacemark {
        do {
            let placemark = try await Geocoder.fetchPlacemark(at: location)
            return placemark
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func fetchCurrentWeather() async -> CurrentWeatherModel {
        guard let coordinate = location?.coordinate else {
            fatalError("Location coordinate unavailable")
        }

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

    private func loadHourlyEntryData() async -> [HourlyEntry] {
        let models = await fetchTwelveHoursForecastWeather()

        var hourlyEntry = [HourlyEntry]()
        for model in models {
            let icon = await fetchIcon(with: model.icon)
            let data = HourlyEntry(
                icon: icon,
                time: model.date.shortTime,
                temperatureValue: TemperatureValue(current: model.temperature)
            )
            hourlyEntry.append(data)
        }
        return hourlyEntry
    }

    private func fetchTwelveHoursForecastWeather() async -> [HourlyForecastModel] {
        guard let coordinate = location?.coordinate else {
            fatalError("Location coordinate unavailable")
        }
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
