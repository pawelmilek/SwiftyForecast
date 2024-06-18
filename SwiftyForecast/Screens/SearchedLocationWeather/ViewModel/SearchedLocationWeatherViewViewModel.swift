//
//  SearchedLocationWeatherViewViewModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//

import Foundation
import MapKit
import SwiftUI

@MainActor
final class SearchedLocationWeatherViewViewModel: ObservableObject {
    @Published private(set) var error: Error?
    @Published private(set) var isLoading = true
    @Published private(set) var addButtonDisabled = true
    @Published private(set) var twentyFourHoursForecast: [HourlyForecastModel]?

    private let location: LocationModel
    private let client: WeatherClient
    private let parser: ResponseParser
    private let databaseManager: DatabaseManager
    private let analyticsManager: AnalyticsManager

    init(
        location: LocationModel,
        client: WeatherClient,
        parser: ResponseParser,
        databaseManager: DatabaseManager,
        analyticsManager: AnalyticsManager
    ) {
        self.location = location
        self.client = client
        self.parser = parser
        self.databaseManager = databaseManager
        self.analyticsManager = analyticsManager
    }

    func loadData() async {
        isLoading = true
        do {
            try await fetchLocationHourlyForecast()
            checkLocationExistance()
            isLoading = false
        } catch {
            isLoading = false
            self.error = error
        }
    }

    func addLocation() {
        do {
            try databaseManager.create(location)
        } catch {
            self.error = error
            fatalError(error.localizedDescription)
        }
        donateAddFavoriteEvent()
        postAppStoreReviewEvent()
        logLocationAdded(name: location.name + ", " + location.country)
    }

    private func fetchLocationHourlyForecast() async throws {
        let forecast = try await client.fetchForecast(
            latitude: location.latitude,
            longitude: location.longitude
        )
        setHourlyForecastItems(parser.parse(forecast: forecast))
    }

    private func setHourlyForecastItems(_ forecastModel: ForecastWeatherModel) {
        let threeHoursForecastItems = 7
        twentyFourHoursForecast = Array(forecastModel.hourly[...threeHoursForecastItems])
    }

    private func checkLocationExistance() {
        addButtonDisabled = (
            try? databaseManager.readBy(
                primaryKey: location.compoundKey
            ) != nil
        ) ?? true
    }

    private func donateAddFavoriteEvent() {
        Task(priority: .userInitiated) {
            await LocationsTip.addFavoriteEvent.donate()
        }
    }

    private func postAppStoreReviewEvent() {
        // TODO: - implement new app store review manager
    }

    private func logLocationAdded(name: String) {
        analyticsManager.send(
            event: LocationWeatherViewEvent.locationAdded(
                name: name
            )
        )
    }

    func logScreenViewed(className: String) {
        analyticsManager.send(
            event: ScreenAnalyticsEvent.screenViewed(
                name: "Searched Location Weather Screen",
                className: "\(type(of: self))"
            )
        )
    }
}
