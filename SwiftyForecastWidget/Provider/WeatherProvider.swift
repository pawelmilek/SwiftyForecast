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
    private let dataSource: WeatherProviderDataSource

    init(dataSource: WeatherProviderDataSource = WeatherProviderDataSource()) {
        self.dataSource = dataSource
    }

    func placeholder(in context: Context) -> WeatherEntry {
        debugPrint("placeholder \(context.family)")
        return WeatherEntry.sampleTimeline.first!
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        Task(priority: .userInitiated) {
            debugPrint("getSnapshot \(context.family)")

            locationManager.stopUpdatingLocation()
            let location = await locationManager.startUpdatingLocation()

            let now = Date.now
            if context.family == .systemSmall {
                let result = await loadWeatherData(for: location)
                let entry = WeatherEntry(
                    date: now,
                    locationName: result.name,
                    icon: result.icon,
                    description: result.description,
                    temperature: result.temperature,
                    temperatureMaxMin: result.temperatureMaxMin,
                    hourly: []
                )
                completion(entry)
            }

            if context.family == .systemMedium {
                let result = await loadWeatherDataWithHourlyForecast(for: location)
                let entry = WeatherEntry(
                    date: now,
                    locationName: result.name,
                    icon: result.icon,
                    description: result.description,
                    temperature: result.temperature,
                    temperatureMaxMin: result.temperatureMaxMin,
                    hourly: result.hourly.compactMap {
                        HourlyEntry(
                            icon: $0.icon,
                            temperature: $0.temperature,
                            time: $0.time
                        )
                    }
                )
                completion(entry)
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        Task(priority: .userInitiated) {
            debugPrint("getTimeline \(context.family)")
            debugPrint("isMainThread \(Thread.isMainThread)")

            let location = await locationManager.startUpdatingLocation()
            let now = Date.now
            var entries = [WeatherEntry]()

            if context.family == .systemSmall {
                let result = await loadWeatherData(for: location)
                let entry = WeatherEntry(
                    date: now,
                    locationName: result.name,
                    icon: result.icon,
                    description: result.description,
                    temperature: result.temperature,
                    temperatureMaxMin: result.temperatureMaxMin,
                    hourly: []
                )

                entries.append(entry)
            }

            if context.family == .systemMedium {
                let result = await loadWeatherDataWithHourlyForecast(for: location)
                let entry = WeatherEntry(
                    date: now,
                    locationName: result.name,
                    icon: result.icon,
                    description: result.description,
                    temperature: result.temperature,
                    temperatureMaxMin: result.temperatureMaxMin,
                    hourly: result.hourly.compactMap {
                        HourlyEntry(
                            icon: $0.icon,
                            temperature: $0.temperature,
                            time: $0.time
                        )
                    }
                )

                entries.append(entry)
            }

            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 45, to: now)!
            let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
            completion(timeline)
        }
    }

    private func loadWeatherData(for location: CLLocation) async -> WeatherProviderDataSource.EntryData {
        debugPrint("loadWeatherData")
        let result = await dataSource.loadEntryData(for: location)
        return result
    }

    private func loadWeatherDataWithHourlyForecast(for location: CLLocation) async -> WeatherProviderDataSource.EntryData {
        debugPrint("loadWeatherDataWithHourlyForecast")
        let result = await dataSource.loadEntryDataWithHourlyForecast(for: location)
        return result
    }
}
