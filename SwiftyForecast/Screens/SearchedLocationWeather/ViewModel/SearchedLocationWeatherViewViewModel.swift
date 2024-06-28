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
    private let service: WeatherServiceProtocol
    private let databaseManager: DatabaseManager
    private let storeReviewManager: StoreReviewManager
    private let analyticsService: AnalyticsService

    init(
        location: LocationModel,
        service: WeatherServiceProtocol,
        databaseManager: DatabaseManager,
        storeReviewManager: StoreReviewManager,
        analyticsService: AnalyticsService
    ) {
        self.location = location
        self.service = service
        self.databaseManager = databaseManager
        self.storeReviewManager = storeReviewManager
        self.analyticsService = analyticsService
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
        storeRequestReview()
        logLocationAdded(name: location.name + ", " + location.country)
    }

    private func fetchLocationHourlyForecast() async throws {
        let forecast = try await service.forecast(
            latitude: location.latitude,
            longitude: location.longitude
        )
        setHourlyForecastItems(forecast)
    }

    private func setHourlyForecastItems(_ forecastModel: ForecastModel) {
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

    private func logLocationAdded(name: String) {
        analyticsService.send(
            event: LocationWeatherViewEvent.locationAdded(
                name: name
            )
        )
    }

    func logScreenViewed(className: String) {
        analyticsService.send(
            event: ScreenAnalyticsEvent.screenViewed(
                name: "Searched Location Weather Screen",
                className: "\(type(of: self))"
            )
        )
    }

    private func storeRequestReview() {
        storeReviewManager.requestReview()
    }
}
