//
//  WeatherProvider.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 12/8/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import WidgetKit
import SwiftUI
import CoreLocation

struct WeatherProvider: TimelineProvider {
    private let locationManager = WidgetLocationManager()
    private let service: WeatherServiceProtocol
    private let notationController: NotationController
    private let temperatureFormatterFactory: TemperatureFormatterFactoryProtocol

    init(
        service: WeatherServiceProtocol = WeatherService(),
        notationController: NotationController = NotationController(),
        temperatureFormatterFactory: TemperatureFormatterFactoryProtocol = TemperatureFormatterFactory()
    ) {
        self.service = service
        self.notationController = notationController
        self.temperatureFormatterFactory = temperatureFormatterFactory
    }

    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry.sampleTimeline.first!
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        Task {
            let (name, model, icon) = await loadWeatherData()

            let values = TemperatureValue(
                current: model.temperature,
                max: model.maxTemperature,
                min: model.minTemperature
            )
            let temp: (current: String, maxMin: String) = temperatureFormatted(valueInKelvin: values)
            let now = Date.now

            let entry = WeatherEntry(
                date: now,
                icon: icon,
                temperature: temp.current,
                temperatureMaxMin: temp.maxMin,
                locationName: name,
                description: model.description
            )

            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        Task {
            let (name, model, icon) = await loadWeatherData()

            let values = TemperatureValue(
                current: model.temperature,
                max: model.maxTemperature,
                min: model.minTemperature
            )

            let (current, maxMin) = temperatureFormatted(valueInKelvin: values)

            let now = Date.now
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 45, to: now)!
            let entry = WeatherEntry(
                date: now,
                icon: icon,
                temperature: current,
                temperatureMaxMin: maxMin,
                locationName: name,
                description: model.description
            )

            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }

    private func loadWeatherData() async -> (String, CurrentWeatherModel, Image) {
        let location = await locationManager.startUpdatingLocation()
        let placemark = await fetchPlacemark(at: location)

        let name = placemark.locality ?? InvalidReference.undefined
        let coordinate = placemark.location?.coordinate ?? location.coordinate
        let model = await fetchCurrentWeather(coordinate: coordinate)
        let icon = await fetchIcon(with: model.icon)
        return (name, model, icon)
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

    private func temperatureFormatted(valueInKelvin source: TemperatureValue) -> (current: String, maxMin: String) {
        let temperatureFormatter = temperatureFormatterFactory.make(
            by: notationController.temperatureNotation,
            valueInKelvin: source
        )

        let temperature = temperatureFormatter.currentFormatted
        let maxTemp = temperatureFormatter.maxFormatted
        let minTemp = temperatureFormatter.minFormatted
        let temperatureMaxMin = "⏶ \(maxTemp)  ⏷ \(minTemp)"
        return (current: temperature, maxMin: temperatureMaxMin)
    }
}
