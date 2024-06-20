//
//  WeatherTimelineProvider.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 12/8/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import WidgetKit
import SwiftUI
import CoreLocation
import Combine

struct WeatherTimelineProvider: TimelineProvider {
    private let locationManager: WidgetLocationManager
    private let entryDataSource: WeatherEntryRepository
    private var cancellables = Set<AnyCancellable>()

    init(locationManager: WidgetLocationManager, entryDataSource: WeatherEntryRepository) {
        self.locationManager = locationManager
        self.entryDataSource = entryDataSource
    }

    func placeholder(in context: Context) -> WeatherEntry {
        return WeatherEntry.sampleTimeline.first!
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        locationManager.stopUpdatingLocation()

        Task(priority: .userInitiated) {
            for await location in locationManager.startUpdatingLocation() {
                if checkIfWidgetFamilyNeedCurrentWeatherOnly(context.family) {
                    let entry = await entryDataSource.load(for: location)
                    completion(entry)
                    return
                }

                if checkIfWidgetFamilyNeedCurrentAndHourlyWeatherForecast(context.family) {
                    let entry = await entryDataSource.loadWithHourlyForecast(for: location)
                    completion(entry)
                    return
                }
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        locationManager.stopUpdatingLocation()

        Task(priority: .userInitiated) {
            for await location in locationManager.startUpdatingLocation() {
                var entries = [WeatherEntry]()

                if checkIfWidgetFamilyNeedCurrentWeatherOnly(context.family) {
                    let entry = await entryDataSource.load(for: location)
                    entries.append(entry)
                }

                if checkIfWidgetFamilyNeedCurrentAndHourlyWeatherForecast(context.family) {
                    let entry = await entryDataSource.loadWithHourlyForecast(for: location)
                    entries.append(entry)
                }

                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 45, to: .now)!
                let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
                completion(timeline)
                return
            }
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
}
