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
    struct CurrentWeatherData {
        let name: String
        let icon: Image
        let description: String
        let temperatureValue: TemperatureValue
        let hourly: [HourlyForecastData]
    }

    struct HourlyForecastData {
        let icon: Image
        let temperatureValue: TemperatureValue
        let time: String

        init(
            icon: Image,
            temperatureValue: TemperatureValue,
            time: String
        ) {
            self.icon = icon
            self.temperatureValue = temperatureValue
            self.time = time
        }
    }

    private let service: WeatherServiceProtocol

    init(service: WeatherServiceProtocol = WeatherService()) {
        self.service = service
    }

    func loadEntryData(for location: CLLocation) async -> CurrentWeatherData {
        let name = await locationName(at: location)
        let currentModel = await fetchCurrentWeather(coordinate: location.coordinate)
        let currentIcon = await fetchIcon(with: currentModel.icon)

        let result = CurrentWeatherData(
            name: name,
            icon: currentIcon,
            description: currentModel.description,
            temperatureValue: currentModel.temperatureValue,
            hourly: []
        )

        return result
    }

    func loadEntryDataWithHourlyForecast(for location: CLLocation) async -> CurrentWeatherData {
        let name = await locationName(at: location)
        let currentModel = await fetchCurrentWeather(coordinate: location.coordinate)
        let currentIcon = await fetchIcon(with: currentModel.icon)
        let hourlyEntryData = await loadHourlyEntryData(coordinate: location.coordinate)

        let result = CurrentWeatherData(
            name: name,
            icon: currentIcon,
            description: currentModel.description,
            temperatureValue: currentModel.temperatureValue,
            hourly: hourlyEntryData
        )

        return result
    }

    private func locationName(at location: CLLocation) async -> String {
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

    private func loadHourlyEntryData(coordinate: CLLocationCoordinate2D) async -> [HourlyForecastData] {
        let models = await fetchTwelveHoursForecastWeather(coordinate: coordinate)

        var hourlyEntryData = [HourlyForecastData]()
        for model in models {
            let icon = await fetchIcon(with: model.icon)
            let data = HourlyForecastData(
                icon: icon,
                temperatureValue: TemperatureValue(current: model.temperature),
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
