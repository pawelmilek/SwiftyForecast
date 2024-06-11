//
//  LocationWeatherViewViewModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//

import Foundation
import MapKit
import SwiftUI
import Combine

@MainActor
final class LocationWeatherViewViewModel: ObservableObject {
    @Published private(set) var error: Error?
    @Published private(set) var isLoading = false
    @Published private(set) var isExistingLocation = true
    @Published private(set) var twentyFourHoursForecastModel: [HourlyForecastModel] = []
    @Published private(set) var shouldShowHourlyForecastChart = false
    @Published private(set) var location: LocationModel?
    @Published private var forecastModel: ForecastWeatherModel?

    private var cancellables = Set<AnyCancellable>()
    private var foundLocation: CLLocation?

    private let searchCompletion: MKLocalSearchCompletion
    private let service: WeatherService
    private let databaseManager: DatabaseManager
    private let appStoreReviewCenter: ReviewNotificationCenter
    private let analyticsManager: AnalyticsManager

    init(
        searchCompletion: MKLocalSearchCompletion,
        service: WeatherService = OpenWeatherMapService(decoder: JSONSnakeCaseDecoded()),
        databaseManager: DatabaseManager = RealmManager.shared,
        appStoreReviewCenter: ReviewNotificationCenter = ReviewNotificationCenter(),
        analyticsManager: AnalyticsManager = AnalyticsManager(service: FirebaseAnalyticsService())
    ) {
        self.searchCompletion = searchCompletion
        self.service = service
        self.databaseManager = databaseManager
        self.appStoreReviewCenter = appStoreReviewCenter
        self.analyticsManager = analyticsManager
        subscriteToPublishers()
    }

    private func subscriteToPublishers() {
        $location
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] locationModel in
                self?.verifyLocationExistanceInDatabase(locationModel)
                self?.loadData()
            }
            .store(in: &cancellables)

        $forecastModel
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] weatherModel in
                setTwentyFourHoursForecastModel(weatherModel.hourly)
            }
            .store(in: &cancellables)
    }

    private func setTwentyFourHoursForecastModel(_ hourly: [HourlyForecastModel]) {
        guard hourly.count >= WeatherViewControllerViewModel.numberOfThreeHoursForecastItems else {
            return
        }

        twentyFourHoursForecastModel = Array(
            hourly[...WeatherViewControllerViewModel.numberOfThreeHoursForecastItems]
        )
        shouldShowHourlyForecastChart = !twentyFourHoursForecastModel.isEmpty
    }

    private func verifyLocationExistanceInDatabase(_ location: LocationModel) {
        do {
            if try databaseManager.readBy(primaryKey: location.compoundKey) != nil {
                isExistingLocation = true
            } else {
                isExistingLocation = false
            }
        } catch {
            self.error = error
        }
    }

    func startSearchRequest() {
        Task(priority: .userInitiated) {
            isLoading = true
            await startSearch()
            await requestPlacemarkIfLocationFound()
            isLoading = false
        }
    }

    private func startSearch() async {
        let searchRequest = MKLocalSearch.Request(completion: searchCompletion)
        let search = MKLocalSearch(request: searchRequest)

        do {
            let response = try await search.start()
            foundLocation = response.mapItems.first?.placemark.location
        } catch {
            isLoading = false
            self.error = error
            debugPrint(error.localizedDescription)
        }
    }

    private func requestPlacemarkIfLocationFound() async {
        guard let foundLocation else { return }

        do {
            let geocodeLocation = GeocodeLocation(geocoder: CLGeocoder())
            let placemark = try await geocodeLocation.requestPlacemark(at: foundLocation)
            location = LocationModel(placemark: placemark)
        } catch {
            isLoading = false
            self.error = error
            debugPrint(error.localizedDescription)
        }
    }

    func loadData() {
        guard let location else { return }
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
                twentyFourHoursForecastModel = []
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
        analyticsManager.log(event: .newLocationAdded(name: name))
    }

    func logScreenViewed(className: String) {
        analyticsManager.log(
            event: .screenViewed(
                name: "Location Weather Screen",
                className: "\(type(of: self))"
            )
        )
    }
}
