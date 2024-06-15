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
    @Published private(set) var location: LocationModel?
    @Published private(set) var twentyFourHoursForecast: [HourlyForecastModel]?

    private let searchedLocation: MKLocalSearchCompletion
    private let service: WeatherClient
    private let databaseManager: DatabaseManager
    private let appStoreReviewCenter: ReviewNotificationCenter
    private let locationPlace: LocationPlaceable
    private let parser: ResponseParser
    private let analyticsManager: AnalyticsManager

    init(
        searchedLocation: MKLocalSearchCompletion,
        service: WeatherClient,
        databaseManager: DatabaseManager,
        appStoreReviewCenter: ReviewNotificationCenter,
        locationPlace: LocationPlaceable,
        parser: ResponseParser,
        analyticsManager: AnalyticsManager
    ) {
        self.searchedLocation = searchedLocation
        self.service = service
        self.databaseManager = databaseManager
        self.appStoreReviewCenter = appStoreReviewCenter
        self.locationPlace = locationPlace
        self.parser = parser
        self.analyticsManager = analyticsManager
    }

    func loadData() async {
        isLoading = true
        do {
            try await fetchLocation()
            try await fetchLocationHourlyForecast()
            checkLocationExistance()
            isLoading = false
        } catch {
            isLoading = false
            self.error = error
        }
    }

    func addLocation() {
        guard let location else { fatalError() }

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

    private func fetchLocation() async throws {
        let searchRequest = MKLocalSearch(
            request: MKLocalSearch.Request(
                completion: searchedLocation
            )
        )

        let response = try await searchRequest.start()
        if let responseLocation = response.mapItems.first?.placemark.location {
            location = try await geocode(location: responseLocation)
        } else {
            throw LocalSearchError.notFound
        }
    }

    private func geocode(location: CLLocation) async throws -> LocationModel {
        let placemark = try await locationPlace.placemark(at: location)
        return LocationModel(placemark: placemark, isUserLocation: false)
    }

    private func fetchLocationHourlyForecast() async throws {
        guard let location else { fatalError() }

        let forecast = try await service.fetchForecast(
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
        guard let location else { fatalError() }
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
        appStoreReviewCenter.post(.locationAdded)
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
