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

            if checkIfWidgetFamilyNeedCurrentWeatherOnly(context.family) {
                let entry = await loadWeatherData(for: location)
                completion(entry)
            }

            if checkIfWidgetFamilyNeedCurrentAndHourlyWeatherForecast(context.family) {
                let entry = await loadWeatherDataWithHourlyForecast(for: location)
                completion(entry)
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        Task(priority: .userInitiated) {
            debugPrint("getTimeline \(context.family)")

            locationManager.stopUpdatingLocation()
            let location = await locationManager.startUpdatingLocation()
            var entries = [WeatherEntry]()

            if checkIfWidgetFamilyNeedCurrentWeatherOnly(context.family) {
                let entry = await loadWeatherData(for: location)
                entries.append(entry)
            }

            if checkIfWidgetFamilyNeedCurrentAndHourlyWeatherForecast(context.family) {
                let entry = await loadWeatherDataWithHourlyForecast(for: location)
                entries.append(entry)
            }

            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 45, to: .now)!
            let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
            completion(timeline)
        }
    }

    private func checkIfWidgetFamilyNeedCurrentWeatherOnly(_ family: WidgetFamily) -> Bool {
        family == .systemSmall
        || family == .accessoryInline
        || family == .accessoryRectangular
        || family == .accessoryCircular
    }

    private func checkIfWidgetFamilyNeedCurrentAndHourlyWeatherForecast(_ family: WidgetFamily) -> Bool {
        family == .systemMedium
    }

    private func loadWeatherData(for location: CLLocation) async -> WeatherEntry {
        debugPrint("loadWeatherData")
        let result = await dataSource.loadEntryData(for: location)
        return result
    }

    private func loadWeatherDataWithHourlyForecast(for location: CLLocation) async -> WeatherEntry {
        debugPrint("loadWeatherDataWithHourlyForecast")
        let result = await dataSource.loadEntryDataWithHourlyForecast(for: location)
        return result
    }
}
