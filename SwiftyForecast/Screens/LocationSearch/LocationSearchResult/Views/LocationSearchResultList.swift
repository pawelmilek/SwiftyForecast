//
//  LocationSearchResultList.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/19/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationSearchResultList: View {
    @Environment(\.dismissSearch) private var dismissSearch
    @EnvironmentObject private var locationSearchCompleter: LocationSearchCompleter
    @StateObject private var searchResultConfig = LocationSearchResultConfiguration()
    @StateObject private var analyticsManager = AnalyticsManager(service: FirebaseAnalyticsService())

    var body: some View {
        List(locationSearchCompleter.searchResults, id: \.self) { item in
            LocationSearchResultRow(result: item) { result in
                searchResultConfig.select(result)
            }
        }
        .background(.background)
        .listStyle(.plain)
        .overlay {
            if shouldShowContentUnavailableView {
                ContentUnavailableView.search(text: locationSearchCompleter.searchText)
                    .background(.background)
            }
        }
        .sheet(isPresented: $searchResultConfig.showSheet) {
            SearchedLocationWeatherView(
                viewModel: SearchedLocationWeatherViewViewModel(
                    searchedLocation: searchResultConfig.searchCompletion,
                    service: OpenWeatherMapService(decoder: JSONSnakeCaseDecoded()),
                    databaseManager: RealmManager.shared,
                    appStoreReviewCenter: ReviewNotificationCenter(),
                    locationPlace: GeocodedLocation(geocoder: CLGeocoder()),
                    analyticsManager: AnalyticsManager(service: FirebaseAnalyticsService())
                ),
                cardViewModel: CurrentWeatherCardViewModel(
                    service: OpenWeatherMapService(decoder: JSONSnakeCaseDecoded()),
                    temperatureRenderer: TemperatureRenderer(),
                    speedRenderer: SpeedRenderer(),
                    measurementSystemNotification: MeasurementSystemNotification()
                ),
                onCancel: dismiss
            )
        }
        .onAppear {
            logScreenViewed()
        }
    }

    private func logScreenViewed() {
        analyticsManager.send(
            event: ScreenAnalyticsEvent.screenViewed(
                name: "Location Search Result",
                className: "\(type(of: self))"
            )
        )
    }

    private var shouldShowContentUnavailableView: Bool {
        return !locationSearchCompleter.searchText.isEmpty
        && locationSearchCompleter.searchResults.isEmpty
    }

    private func dismiss() {
        dismissSearch()
        searchResultConfig.hideSheet()
        locationSearchCompleter.removeAllResults()
    }
}

#Preview {
    LocationSearchResultList()
        .environmentObject(LocationSearchCompleter())
}
