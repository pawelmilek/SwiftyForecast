//
//  LocationSearchResults.swift
//  SwiftyForecast
//
//  Created by Pawel Milek on 11/19/23.
//  Copyright © 2023 Pawel Milek. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationSearchResults: View {
    @Environment(\.dismissSearch) private var dismissSearch
    @EnvironmentObject private var locationSearchCompleter: LocationSearchCompleter
    @StateObject private var searchResultConfig = LocationSearchResultConfiguration(
        localSearch: MKLocalSearchCompletion()
    )
    @StateObject private var analyticsManager = AnalyticsManager(
        service: FirebaseAnalyticsService()
    )

    var body: some View {
        List(locationSearchCompleter.searchResults, id: \.self) { item in
            LocationSearchRow(result: item) { result in
                searchResultConfig.select(result)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .background(.background)
        .listStyle(.plain)
        .overlay {
            ContentUnavailableView
                .search(text: locationSearchCompleter.searchText)
                .background(.background)
                .opacity(shouldShowContentUnavailableView ? 1.0 : 0.0)
        }
        .sheet(isPresented: $searchResultConfig.showSearchedLocationForecast) {
            SearchedLocationWeatherView(
                viewModel: SearchedLocationWeatherViewViewModel(
                    searchedLocation: searchResultConfig.localSearch,
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
    LocationSearchResults()
        .environmentObject(LocationSearchCompleter())
}
