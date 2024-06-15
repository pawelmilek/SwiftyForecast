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
    @Environment(\.analyticsManager) private var analyticsManager
    @Environment(\.locationSearchCompleter) private var locationSearchCompleter
    @StateObject private var searchResultConfig = LocationSearchResultConfiguration(
        localSearch: MKLocalSearchCompletion()
    )

    var body: some View {
        List(locationSearchCompleter.searchResults, id: \.self) { item in
            LocationSearchRow(result: item) { result in
                searchResultConfig.select(result) // TODO: Execute fetech location here!
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
                    service: OpenWeatherMapClient(decoder: JSONSnakeCaseDecoded()),
                    databaseManager: RealmManager.shared,
                    appStoreReviewCenter: ReviewNotificationCenter(),
                    locationPlace: GeocodedLocation(geocoder: CLGeocoder()),
                    parser: ResponseParser(),
                    analyticsManager: AnalyticsManager(service: FirebaseAnalyticsService())
                ),
                cardViewModel: CurrentWeatherCardViewModel(
                    location: LocationModel.examples.first!, // TODO: remove after refactored
                    client: OpenWeatherMapClient(decoder: JSONSnakeCaseDecoded()),
                    temperatureRenderer: TemperatureRenderer(),
                    speedRenderer: SpeedRenderer(),
                    measurementSystemNotification: MeasurementSystemNotification()
                ),
                onCancel: dismiss
            )
            .interactiveDismissDisabled()
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
}
