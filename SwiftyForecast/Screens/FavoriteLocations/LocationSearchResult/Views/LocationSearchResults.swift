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
    @Environment(\.analyticsService) private var analyticsService
    @Environment(\.locationSearchCompleter) private var locationSearchCompleter
    @Environment(\.client) private var client
    @Environment(\.databaseManager) private var databaseManager
    @StateObject private var searchLocationStore = SearchLocationStore(
        locationPlace: GeocodedLocation(geocoder: CLGeocoder())
    )

    var body: some View {
        List(locationSearchCompleter.searchResults, id: \.self) { item in
            LocationSearchRow(result: item) { result in
                Task {
                    await searchLocationStore.fetchLocation(result)
                }
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
        .sheet(item: $searchLocationStore.foundLocation) { foundLocation in
            SearchedLocationWeatherView(
                viewModel: CompositionRoot.searchedLocationWeatherViewModel(
                    foundLocation
                ),
                cardViewModel: CompositionRoot.cardViewModel(
                    latitude: foundLocation.latitude,
                    longitude: foundLocation.longitude,
                    name: foundLocation.name
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
        analyticsService.send(
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
        searchLocationStore.clearFoundLocation()
        locationSearchCompleter.removeAllResults()
    }
}

#Preview {
    LocationSearchResults()
}
