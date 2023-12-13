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
        WeatherEntry.sampleTimeline.first!
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        Task(priority: .userInitiated) {
            let result = await loadWeatherDataForCurrentLocation()
            let now = Date.now

            let entry = WeatherEntry(
                date: now,
                locationName: result.name,
                icon: result.icon,
                description: result.description,
                temperature: result.temperature,
                temperatureMaxMin: result.temperatureMaxMin
            )

            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        Task(priority: .userInitiated) {
            let result = await loadWeatherDataForCurrentLocation()
            let now = Date.now

            let entry = WeatherEntry(
                date: now,
                locationName: result.name,
                icon: result.icon,
                description: result.description,
                temperature: result.temperature,
                temperatureMaxMin: result.temperatureMaxMin
            )

            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 45, to: now)!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }

    private func loadWeatherDataForCurrentLocation() async -> WeatherProviderDataSource.EntryData {
        let location = await locationManager.startUpdatingLocation()
        let result = await dataSource.loadEntryData(for: location)
        return result
    }
}
