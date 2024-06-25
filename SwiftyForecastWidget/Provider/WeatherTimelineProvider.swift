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
    private let repositoryFactory: EntryServiceFactory
    private var cancellables = Set<AnyCancellable>()

    init(locationManager: WidgetLocationManager, repositoryFactory: EntryServiceFactory) {
        self.locationManager = locationManager
        self.repositoryFactory = repositoryFactory
    }

    func placeholder(in context: Context) -> WeatherEntry {
        return WeatherEntry.sampleTimeline.first!
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        locationManager.stopUpdatingLocation()
        let repository = repositoryFactory.make(isSystemMediumFamily(context.family))

        Task(priority: .userInitiated) {
            for await location in locationManager.startUpdatingLocation() {
                let entry = await repository.load(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
                completion(entry)
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        locationManager.stopUpdatingLocation()
        let repository = repositoryFactory.make(isSystemMediumFamily(context.family))

        Task(priority: .userInitiated) {
            for await location in locationManager.startUpdatingLocation() {
                var entries = [WeatherEntry]()
                let entry = await repository.load(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
                entries.append(entry)

                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 45, to: .now)!
                let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
                completion(timeline)
                return
            }
        }
    }

    private func isSystemMediumFamily(_ family: WidgetFamily) -> Bool {
        family == .systemMedium
    }
}
