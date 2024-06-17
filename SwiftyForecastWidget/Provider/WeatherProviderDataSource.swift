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
    private let client: WeatherClient
    private var location: CLLocation?

    init(client: WeatherClient) {
        self.client = client
    }

    func loadEntryData(for location: CLLocation) async -> WeatherEntry {
        self.location = location
        let (name, currentModel) = await fetchLocationNameAndCurrentWeather()
        let icon = await fetchIcon(with: currentModel.condition.iconCode)

        let result = WeatherEntry(
            date: .now,
            locationName: name,
            icon: icon,
            description: currentModel.condition.description,
            temperatureValue: currentModel.temperature,
            dayNightState: currentModel.condition.state,
            hourly: []
        )

        return result
    }

    func loadEntryDataWithHourlyForecast(for location: CLLocation) async -> WeatherEntry {
        self.location = location
        let (name, currentModel) = await fetchLocationNameAndCurrentWeather()
        let (icon, hourlyEntryData) = await fetchConditionIconAndHourlyForecast(currentModel.condition.iconCode)

        let result = WeatherEntry(
            date: .now,
            locationName: name,
            icon: icon,
            description: currentModel.condition.description,
            temperatureValue: currentModel.temperature,
            dayNightState: currentModel.condition.state,
            hourly: hourlyEntryData
        )

        return result
    }

    private func fetchLocationNameAndCurrentWeather() async -> (name: String, model: WeatherModel) {
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

        let placemark = await requestPlacemark(at: location)
        let name = placemark.locality ?? InvalidReference.undefined
        return name
    }

    private func requestPlacemark(at location: CLLocation) async -> CLPlacemark {
        do {
            let geocodeLocation = GeocodedLocation(geocoder: CLGeocoder())
            let placemark = try await geocodeLocation.placemark(at: location)
            return placemark
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func fetchCurrentWeather() async -> WeatherModel {
        guard let coordinate = location?.coordinate else {
            fatalError("Location coordinate unavailable")
        }

        do {
            let response = try await client.fetchCurrent(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            let model = ResponseParser().parse(current: response)
            return model
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func fetchIcon(with symbol: String) async -> Image {
        do {
            let result = try await client.fetchLargeIcon(symbol: symbol)
            if let uiImage = UIImage(data: result) {
                return Image(uiImage: uiImage)
            } else {
                fatalError()
            }

        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func loadHourlyEntryData() async -> [HourlyEntry] {
        let models = await fetchTwelveHoursForecastWeather()

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

    private func fetchTwelveHoursForecastWeather() async -> [HourlyForecastModel] {
        guard let coordinate = location?.coordinate else {
            fatalError("Location coordinate unavailable")
        }
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
