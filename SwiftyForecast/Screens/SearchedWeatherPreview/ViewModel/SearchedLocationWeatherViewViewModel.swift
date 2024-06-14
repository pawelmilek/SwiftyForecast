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
    @Published private(set) var isLoading = true
    @Published private(set) var addButtonDisabled = true
    @Published private(set) var location: LocationModel?
    @Published private(set) var forecastModel: ForecastWeatherModel?
    @Published private(set) var twentyFourHoursForecastModel: [HourlyForecastModel]?

    private let threeHoursForecastItems = 7
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
                self?.disableAddButtonWhenExist(location: location)
                self?.fetchForecast(location)
            }
            .store(in: &cancellables)

        $forecastModel
            .compactMap { $0?.hourly[...self.threeHoursForecastItems] }
            .map { Array($0) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] twentyFourHoursForecastModel in
                self?.twentyFourHoursForecastModel = twentyFourHoursForecastModel
            }
            .store(in: &cancellables)
    }

    private func disableAddButtonWhenExist(location: LocationModel) {
        addButtonDisabled = (
            try? databaseManager.readBy(
                primaryKey: location.compoundKey
            ) != nil
        ) ?? true
    }

    func loadData() async {
        do {
            isLoading = true
            try await fetchLocation()
            isLoading = false
        } catch {
            isLoading = false
            self.error = error
        }
    }

    private func fetchLocation() async throws {
        let searchRequest = MKLocalSearch(
            request: MKLocalSearch.Request(
                completion: searchedLocation
            )
        )

        let response = try await searchRequest.start()
        if let location = response.mapItems.first?.placemark.location {
            try await geocode(location: location)
        } else {
            throw LocalSearchError.notFound
        }
    }

    private func geocode(location: CLLocation) async throws {
        let placemark = try await locationPlace.placemark(at: location)
        self.location = LocationModel(placemark: placemark, isUserLocation: false)
    }

    func fetchForecast(_ location: LocationModel) {
        isLoading = true
        Task {
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
        logNewLocationAdded(name: location.name + ", " + location.country)
    }

    private func donateAddFavoriteEvent() {
        Task(priority: .userInitiated) {
            await LocationsTip.addFavoriteEvent.donate()
        }
    }

    private func postAppStoreReviewEvent() {
        appStoreReviewCenter.post(.locationAdded)
    }

    private func logNewLocationAdded(name: String) {
        analyticsManager.send(
            event: LocationWeatherViewEvent.newLocationAdded(
                name: name
            )
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
