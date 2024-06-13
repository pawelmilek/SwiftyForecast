//
//  SearchedLocationWeatherViewViewModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//

import Foundation
import MapKit
import SwiftUI
import Combine

@MainActor
final class SearchedLocationWeatherViewViewModel: ObservableObject {
    @Published private(set) var error: Error?
    @Published private(set) var isLoading = false
    @Published private(set) var isExistingLocation = true
    @Published private(set) var location: LocationModel?
    @Published private(set) var forecastModel: ForecastWeatherModel?
    @Published private(set) var twentyFourHoursForecastModel: [HourlyForecastModel]?

    private let threeHoursForecastItems = 8
    private var cancellables = Set<AnyCancellable>()
    private let searchedLocation: MKLocalSearchCompletion
    private let service: WeatherService
    private let databaseManager: DatabaseManager
    private let appStoreReviewCenter: ReviewNotificationCenter
    private let locationPlace: LocationPlaceable
    private let analyticsManager: AnalyticsManager

    init(
        searchedLocation: MKLocalSearchCompletion,
        service: WeatherService,
        databaseManager: DatabaseManager,
        appStoreReviewCenter: ReviewNotificationCenter,
        locationPlace: LocationPlaceable,
        analyticsManager: AnalyticsManager
    ) {
        self.searchedLocation = searchedLocation
        self.service = service
        self.databaseManager = databaseManager
        self.appStoreReviewCenter = appStoreReviewCenter
        self.locationPlace = locationPlace
        self.analyticsManager = analyticsManager
        subscriteToPublishers()
    }

    private func subscriteToPublishers() {
        $location
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.verifyLocationExistanceInDatabase(location)
                self?.loadData(location)
            }
            .store(in: &cancellables)

        $forecastModel
            .compactMap { $0?.hourly[...self.threeHoursForecastItems] }
            .map {  Array($0.prefix(upTo: self.threeHoursForecastItems)) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] twentyFourHoursForecastModel in
                self?.twentyFourHoursForecastModel = twentyFourHoursForecastModel
            }
            .store(in: &cancellables)
    }

    private func verifyLocationExistanceInDatabase(_ location: LocationModel) {
        do {
            isExistingLocation = try databaseManager.readBy(primaryKey: location.compoundKey) != nil
        } catch {
            self.error = error
        }
    }

    func startSearchRequest() {
        Task(priority: .userInitiated) {
            isLoading = true
            await fetchPlacemark()
            isLoading = false
        }
    }

    private func fetchPlacemark() async {
        let searchRequest = MKLocalSearch.Request(completion: searchedLocation)
        let search = MKLocalSearch(request: searchRequest)

        do {
            let response = try await search.start()
            if let foundLocation = response.mapItems.first?.placemark.location {
                try await geocode(location: foundLocation)
            } else {
                fatalError()
            }

        } catch {
            isLoading = false
            self.error = error
            debugPrint(error.localizedDescription)
        }
    }

    private func geocode(location: CLLocation) async throws {
        let placemark = try await locationPlace.placemark(at: location)
        self.location = LocationModel(placemark: placemark, isUserLocation: false)
    }

    func loadData(_ location: LocationModel) {
        guard !isLoading else { return }
        isLoading = true

        Task(priority: .userInitiated) {
            do {
                let forecast = try await service.fetchForecast(
                    latitude: location.latitude,
                    longitude: location.longitude
                )
                forecastModel = ResponseParser().parse(forecast: forecast)
                isLoading = false
            } catch {
                forecastModel = nil
                twentyFourHoursForecastModel = nil
                self.error = error
                isLoading = false
            }
        }
    }

    func addNewLocation() {
        guard let location else { return }
        do {
            try databaseManager.create(location)
        } catch {
            fatalError(error.localizedDescription)
        }
        donateAddFavoriteEvent()
        postAppStoreReviewEvent()
        logAddNewLocation(name: location.name + ", " + location.country)
    }

    private func donateAddFavoriteEvent() {
        Task(priority: .userInitiated) {
            await LocationsTip.addFavoriteEvent.donate()
        }
    }

    private func postAppStoreReviewEvent() {
        appStoreReviewCenter.post(.locationAdded)
    }

    private func logAddNewLocation(name: String) {
        analyticsManager.send(
            event: LocationWeatherViewEvent.newLocationAdded(name: name)
        )
    }

    func logScreenViewed(className: String) {
        analyticsManager.send(
            event: ScreenAnalyticsEvent.screenViewed(
                name: "Location Weather Screen",
                className: "\(type(of: self))"
            )
        )
    }
}
