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
    @Environment(\.weatherClient) private var weatherClient
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
                viewModel: SearchedLocationWeatherViewViewModel(
                    location: foundLocation,
                    client: weatherClient,
                    parser: ResponseParser(),
                    databaseManager: databaseManager,
                    analyticsManager: AnalyticsManager(service: FirebaseAnalyticsService())
                ),
                cardViewModel: WeatherCardViewViewModel(
                    latitude: foundLocation.latitude,
                    longitude: foundLocation.longitude,
                    locationName: foundLocation.name,
                    client: weatherClient,
                    parser: ResponseParser(),
                    temperatureFormatterFactory: TemperatureFormatterFactory(
                        notationStorage: NotationSettingsStorage()
                    ),
                    speedFormatterFactory: SpeedFormatterFactory(
                        notationStorage: NotationSettingsStorage()
                    ),
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
        searchLocationStore.clearFoundLocation()
        locationSearchCompleter.removeAllResults()
    }
}

#Preview {
    LocationSearchResults()
}
