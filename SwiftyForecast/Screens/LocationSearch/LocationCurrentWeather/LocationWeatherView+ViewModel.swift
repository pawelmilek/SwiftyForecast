//
//  LocationWeatherView+ViewModel.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 10/22/23.
//

import Foundation
import MapKit
import SwiftUI
import Combine

extension LocationWeatherView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published private(set) var error: Error?
        @Published private(set) var isLoading = false
        @Published private(set) var isExistingLocation = true
        @Published private(set) var twentyFourHoursForecastModel: [HourlyForecastModel] = []
        @Published private(set) var shouldShowHourlyForecastChart = false
        @Published private(set) var locationModel: LocationModel?
        @Published private var forecastModel: ForecastWeatherModel?

        private var cancellables = Set<AnyCancellable>()
        private var foundLocation: CLLocation?

        private let searchCompletion: MKLocalSearchCompletion
        private let service: WeatherServiceProtocol
        private let databaseManager: DatabaseManager
        private let appStoreReviewCenter: ReviewNotificationCenter

        init(searchCompletion: MKLocalSearchCompletion,
             service: WeatherServiceProtocol = WeatherService(),
             databaseManager: DatabaseManager = RealmManager.shared,
             appStoreReviewCenter: ReviewNotificationCenter = ReviewNotificationCenter()) {
            self.searchCompletion = searchCompletion
            self.service = service
            self.databaseManager = databaseManager
            self.appStoreReviewCenter = appStoreReviewCenter
            subscriteToPublishers()
            debugPrint("LocationSearchResultView.ViewModel init")
        }

        private func subscriteToPublishers() {
            $locationModel
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
            guard hourly.count >= WeatherViewController.ViewModel.numberOfThreeHoursForecastItems else {
                return
            }

            twentyFourHoursForecastModel = Array(
                hourly[...WeatherViewController.ViewModel.numberOfThreeHoursForecastItems]
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
                await fetchPlacemarkIfLocationFound()
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

        private func fetchPlacemarkIfLocationFound() async {
            guard let foundLocation else { return }

            do {
                let placemark = try await Geocoder.fetchPlacemark(at: foundLocation)
                locationModel = LocationModel(placemark: placemark)
            } catch {
                isLoading = false
                self.error = error
                debugPrint(error.localizedDescription)
            }
        }

        func loadData() {
            guard let locationModel else { return }
            guard !isLoading else { return }
            isLoading = true

            Task(priority: .userInitiated) {
                do {
                    let forecast = try await service.fetchForecast(
                        latitude: locationModel.latitude,
                        longitude: locationModel.longitude
                    )
                    forecastModel = ResponseParser.parse(forecast: forecast)
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
            guard let locationModel else { return }
            do {
                try databaseManager.create(locationModel)
            } catch {
                fatalError(error.localizedDescription)
            }
            donateAddFavoriteEvent()
            postAppStoreReviewEvent()
        }

        private func donateAddFavoriteEvent() {
            Task(priority: .userInitiated) {
                await LocationsTip.addFavoriteEvent.donate()
            }
        }

        private func postAppStoreReviewEvent() {
            appStoreReviewCenter.post(.locationAdded)
        }
    }

}
